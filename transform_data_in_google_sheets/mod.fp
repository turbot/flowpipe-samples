mod "transform_data_in_google_sheets" {
  title       = "Find and Replace Text"
  description = "Find and replace specific text across all google spreadsheet."

  require {
    mod "github.com/turbot/flowpipe-mod-googleworkspace" {
      version = "v0.0.1-rc.6"
      args = {
        access_token  = var.access_token
      }
    }
  }
}
