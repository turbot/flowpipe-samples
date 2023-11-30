mod "secure_snapshot_gcp_instance" {
  title       = "Snapshotting and Isolating Google Cloud Instance with Disk Detachment and Firewall Rules"
  description = "Capturing instance state with Snapshot, detaching disks, and enforcing isolation with firewall rules for enhanced security in Google Cloud."

  require {
    mod "github.com/turbot/flowpipe-mod-gcp" {
      version = "*"
      args = {
        project_id                   = var.gcp_project_id
        application_credentials_path = var.gcp_application_credentials_path
      }
    }
  }

}
