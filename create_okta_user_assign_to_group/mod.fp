mod "create_okta_user_assign_to_group" {
  title       = "Create User and Assign Group"
  description = "Create a user in Okta and assign to a group."

  require {
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "v0.0.2-rc.2"
      args = {
        api_token = var.api_token
        domain    = var.domain
      }
    }
  }
}