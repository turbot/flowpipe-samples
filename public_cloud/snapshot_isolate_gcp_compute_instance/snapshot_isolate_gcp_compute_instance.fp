pipeline "snapshot_isolate_gcp_compute_instance" {
  title       = "Snapshot and Isolate GCP Compute Instance"
  description = "For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic."

  param "gcp_cred" {
    type        = string
    description = "Name for GCP credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "jira_cred" {
    type        = string
    description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "jira_project_key" {
    type        = string
    description = "The Jira project key."
  }

  param "jira_issue_type" {
    type        = string
    description = "The Jira issue type."
  }

  param "gcp_project_id" {
    type        = string
    description = "The GCP project ID."
  }

  param "gcp_zone" {
    type        = string
    description = "The GCP zone."
    default     = var.gcp_zone
  }

  param "gcp_instance_name" {
    type        = string
    description = "The GCP instance name."
  }

  step "pipeline" "get_compute_instance" {
    pipeline = gcp.pipeline.get_compute_instance
    args = {
      cred          = param.gcp_cred
      instance_name = param.gcp_instance_name
      project_id    = param.gcp_project_id
      zone          = param.gcp_zone
    }
  }

  step "pipeline" "create_compute_snapshot" {
    depends_on = [step.pipeline.get_compute_instance]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.instance.disks : disk.source => disk }
    pipeline   = gcp.pipeline.create_compute_snapshot
    args = {
      cred             = param.gcp_cred
      source_disk_name = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
      project_id       = param.gcp_project_id
      snapshot_name    = "isolate-disk-${regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]}"
      source_disk_zone = regex("projects/.+/zones/(.+)/disks/.+", each.key)[0]
    }
  }

  step "pipeline" "stop_compute_instance" {
    depends_on = [step.pipeline.create_compute_snapshot]
    pipeline   = gcp.pipeline.stop_compute_instance
    args = {
      cred          = param.gcp_cred
      instance_name = param.gcp_instance_name
      project_id    = param.gcp_project_id
      zone          = param.gcp_zone
    }
  }

  step "pipeline" "detach_compute_disk_from_instance" {
    depends_on = [step.pipeline.stop_compute_instance]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.instance.disks : disk.source => disk }
    pipeline   = gcp.pipeline.detach_compute_disk_from_instance
    args = {
      cred          = param.gcp_cred
      instance_name = param.gcp_instance_name
      project_id    = param.gcp_project_id
      zone          = param.gcp_zone
      disk_name     = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
    }
  }

  step "pipeline" "create_ingress_vpc_firewall_rule" {
    depends_on = [step.pipeline.detach_compute_disk_from_instance]
    pipeline   = gcp.pipeline.create_vpc_firewall_rule
    args = {
      cred               = param.gcp_cred
      project_id         = param.gcp_project_id
      network_name       = regex("projects/.+/global/networks/(.+)", step.pipeline.get_compute_instance.output.instance.networkInterfaces[0].network)[0]
      firewall_rule_name = "block-ingress"
      priority           = "1000"
      direction          = "INGRESS"
      action             = "DENY"
      rules              = ["all"]
    }
  }

  step "pipeline" "create_egress_vpc_firewall_rule" {
    depends_on = [step.pipeline.create_ingress_vpc_firewall_rule]
    pipeline   = gcp.pipeline.create_vpc_firewall_rule
    args = {
      cred               = param.gcp_cred
      project_id         = param.gcp_project_id
      network_name       = regex("projects/.+/global/networks/(.+)", step.pipeline.get_compute_instance.output.instance.networkInterfaces[0].network)[0]
      firewall_rule_name = "block-egress"
      priority           = "1000"
      direction          = "EGRESS"
      action             = "DENY"
      rules              = ["all"]
    }
  }

  step "pipeline" "create_issue" {
    depends_on = [step.pipeline.create_egress_vpc_firewall_rule]
    pipeline   = jira.pipeline.create_issue
    args = {
      cred        = param.jira_cred
      summary     = "Isolated GCP instance ${param.gcp_instance_name}"
      description = " - Created snapshots: ${join(", ", [for disk in step.pipeline.get_compute_instance.output.instance.disks : "isolate-disk-${regex("projects/.+/zones/.+/disks/(.+)", disk.source)[0]}"])}\n - Detached disks: ${join(", ", [for disk in step.pipeline.get_compute_instance.output.instance.disks : regex("projects/.+/zones/.+/disks/(.+)", disk.source)[0]])}\n - Created VPC firewall rules to block ingress and egress traffic"
      project_key = param.jira_project_key
      issue_type  = param.jira_issue_type
    }
  }

  output "output" {
    value = !is_error(step.pipeline.create_egress_vpc_firewall_rule) ? "Created snapshots for disks, detached disks, and blocked ingress/egress traffic for instance ${param.gcp_instance_name}" : "Failed to snapshot and isolate instance"
  }
}
