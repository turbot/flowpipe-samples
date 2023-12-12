pipeline "snapshot_isolate_gcp_compute_instance" {
  title       = "Snapshot and Isolate GCP Compute Instance"
  description = "For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic."

  param "project_id" {
    type        = string
    description = "The GCP project ID."
    default     = var.gcp_project_id
  }

  param "zone" {
    type        = string
    description = "The GCP zone."
    default     = var.gcp_zone
  }

  param "instance_name" {
    type        = string
    description = "The GCP instance name."
  }

  step "pipeline" "get_compute_instance" {
    pipeline = gcp.pipeline.get_compute_instance
    args = {
      instance_name = param.instance_name
      project_id    = param.project_id
      zone          = param.zone
    }
  }

  step "pipeline" "create_compute_snapshot" {
    depends_on = [step.pipeline.get_compute_instance]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.instance.disks : disk.source => disk }
    pipeline   = gcp.pipeline.create_compute_snapshot
    args = {
      source_disk_name = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
      project_id       = param.project_id
      snapshot_name    = "isolate-disk-${regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]}"
      source_disk_zone = regex("projects/.+/zones/(.+)/disks/.+", each.key)[0]
    }
  }

  step "pipeline" "stop_compute_instance" {
    depends_on = [step.pipeline.create_compute_snapshot]
    pipeline   = gcp.pipeline.stop_compute_instance
    args = {
      instance_name = param.instance_name
      project_id    = param.project_id
      zone          = param.zone
    }
  }

  step "pipeline" "detach_compute_instance_from_disk" {
    depends_on = [step.pipeline.stop_compute_instance]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.instance.disks : disk.source => disk }
    pipeline   = gcp.pipeline.detach_compute_instance_from_disk
    args = {
      instance_name = param.instance_name
      project_id    = param.project_id
      zone          = param.zone
      disk_name     = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
    }
  }

  step "pipeline" "create_ingress_vpc_firewall_rule" {
    depends_on = [step.pipeline.detach_compute_instance_from_disk]
    pipeline   = gcp.pipeline.create_vpc_firewall_rule
    args = {
      project_id         = param.project_id
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
      project_id         = param.project_id
      network_name       = regex("projects/.+/global/networks/(.+)", step.pipeline.get_compute_instance.output.instance.networkInterfaces[0].network)[0]
      firewall_rule_name = "block-egress"
      priority           = "1000"
      direction          = "EGRESS"
      action             = "DENY"
      rules              = ["all"]
    }
  }

  output "output" {
    value = !is_error(step.pipeline.create_egress_vpc_firewall_rule) ? "Created snapshots for disks, detached disks, and blocked ingress/egress traffic for instance ${param.instance_name}" : "Failed to snapshot and isolate instance"
  }
}
