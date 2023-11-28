pipeline "gcp_isolate_instance" {
  title       = "Isolate GCP Instance"
  description = "Isolate GCP Instance."

  param "application_credentials_path" {
    type        = string
    description = "Application Credentials Path"
    default     = var.gcp_application_credentials_path
  }

  param "instance_name" {
    type        = "string"
    description = "Instance Name"
    default     = "instance-1"
  }

  param "project_id" {
    type        = "string"
    description = "Project ID"
    default     = var.gcp_project_id
  }

  param "zone" {
    type        = "string"
    description = "Zone"
    default     = "us-central1-a"
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
}
