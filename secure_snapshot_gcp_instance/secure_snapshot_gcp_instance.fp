pipeline "secure_snapshot_gcp_instance" {
  title       = "Snapshotting and Isolating Google Cloud Instance with Disk Detachment and Firewall Rules"
  description = "Capturing instance state with Snapshot, detaching disks, and enforcing isolation with firewall rules for enhanced security in Google Cloud."

  param "application_credentials_path" {
    type        = string
    description = "Application Credentials Path"
    default     = var.gcp_application_credentials_path
  }

  param "instance_name" {
    type        = "string"
    description = "Instance Name"
  }

  param "project_id" {
    type        = "string"
    description = "Project ID"
    default     = var.gcp_project_id
  }

  param "zone" {
    type        = "string"
    description = "Zone"
  }

  step "pipeline" "get_compute_instance" {
    pipeline = gcp.pipeline.get_compute_instance
    args = {
      application_credentials_path = param.application_credentials_path
      instance_name                = param.instance_name
      project_id                   = param.project_id
      zone                         = param.zone
    }
  }

  step "pipeline" "create_compute_snapshot" {
    depends_on = [step.pipeline.get_compute_instance]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.stdout.disks : disk.source => disk }
    pipeline   = gcp.pipeline.create_compute_snapshot
    args = {
      application_credentials_path = param.application_credentials_path
      source_disk_name             = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
      project_id                   = param.project_id
      snapshot_name                = "snapshot-1"
      source_disk_zone             = regex("projects/.+/zones/(.+)/disks/.+", each.key)[0]
    }
  }

  step "sleep" "sleep" {
    depends_on = [step.pipeline.create_compute_snapshot]
    duration   = "20s"
  }

  step "pipeline" "detach_compute_instance_from_disk" {
    depends_on = [step.sleep.sleep]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.stdout.disks : disk.source => disk }
    pipeline   = gcp.pipeline.detach_compute_instance_from_disk
    args = {
      application_credentials_path = param.application_credentials_path
      instance_name                = param.instance_name
      project_id                   = param.project_id
      zone                         = param.zone
      disk_name                    = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
    }
  }

  step "pipeline" "create_ingress_vpc_firewall_rule" {
    depends_on = [step.pipeline.detach_compute_instance_from_disk]
    pipeline   = gcp.pipeline.create_vpc_firewall_rule
    args = {
      application_credentials_path = param.application_credentials_path
      project_id                   = param.project_id
      network_name                 = regex("projects/.+/global/networks/(.+)", step.pipeline.get_compute_instance.output.stdout.networkInterfaces[0].network)[0]
      firewall_rule_name           = "block-ingress"
      priority                     = "1000"
      direction                    = "INGRESS"
      action                       = "DENY"
      rules                        = ["all"]
    }
  }

  step "pipeline" "create_egress_vpc_firewall_rule" {
    depends_on = [step.pipeline.create_ingress_vpc_firewall_rule]
    pipeline   = gcp.pipeline.create_vpc_firewall_rule
    args = {
      application_credentials_path = param.application_credentials_path
      project_id                   = param.project_id
      network_name                 = regex("projects/.+/global/networks/(.+)", step.pipeline.get_compute_instance.output.stdout.networkInterfaces[0].network)[0]
      firewall_rule_name           = "block-egress"
      priority                     = "1000"
      direction                    = "EGRESS"
      action                       = "DENY"
      rules                        = ["all"]
    }
  }

  step "pipeline" "delete_compute_disk" {
    depends_on = [step.pipeline.create_egress_vpc_firewall_rule]
    for_each   = { for disk in step.pipeline.get_compute_instance.output.stdout.disks : disk.source => disk }
    pipeline   = gcp.pipeline.delete_compute_disk
    args = {
      application_credentials_path = param.application_credentials_path
      project_id                   = param.project_id
      zone                         = param.zone
      disk_name                    = regex("projects/.+/zones/.+/disks/(.+)", each.key)[0]
    }
  }
}
