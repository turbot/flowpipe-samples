mod "snapshot_isolate_gcp_compute_instance" {
  title         = "Snapshot and Isolate GCP Compute Instance"
  description   = "For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic."
  documentation = file("./README.md")
  categories    = ["public cloud", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-gcp" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "^1"
    }
  }
}
