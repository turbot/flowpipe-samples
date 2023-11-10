mod "add_user_to_multiple_services" {
  title = "Add User to Multiple Services"
  description = "Adds a user to multiple services."

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1"
      args = {
        access_token = var.github_access_token
      }
    }
  }

  require {
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "v0.0.1-rc.2"
      args = {
        api_token   = var.okta_api_token
        okta_domain = var.okta_domain
      }
    }
  }

}
