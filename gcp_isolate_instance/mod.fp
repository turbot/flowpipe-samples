mod "gcp_isolate_instance" {
  title       = "Isolate GCP Instance"
  description = "Isolate GCP Instance."

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
