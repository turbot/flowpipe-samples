mod "import_csv_to_googlesheet" {
  title       = "Import Data from Remote CSV URL in Googlesheet"
  description = "Import data from remote CSV url to new googlesheet."

  require {
    mod "github.com/turbot/flowpipe-mod-googleworkspace" {
      version = "0.0.1-rc.2"
      args = {
        access_token  = var.access_token
        client_secret = var.client_secret
        client_id     = var.client_id
        code          = var.code
      }
    }
  }
}
