mod "snapshot_isolate_gcp_compute_instance" {
  title       = "Snapshot and Isolate GCP Compute Instance"
  description = "For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic."
  categories  = ["public cloud"]
  require {
    mod "github.com/turbot/flowpipe-mod-gcp" {
      version = "0.0.1-rc.3"
      args = {
        project_id = var.gcp_project_id
      }
    }
  }

}
