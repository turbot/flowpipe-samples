mod "offboard_azuread_users" {
  title       = "Jira integration for Azure AD users"
  description = " TO DO."

  require {
    mod "github.com/turbot/flowpipe-mod-azure" {
      version = "v0.0.1-rc.2"
      args = {
        subscription_id = var.subscription_id
        tenant_id       = var.tenant_id
        client_secret   = var.client_secret
        client_id       = var.client_id
        resource_group  = var.resource_group
      }
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.2"
      args = {
        token        = var.token
        user_email   = var.user_email
        api_base_url = var.api_base_url
        project_key  = var.project_key
      }
    }
  }
}
