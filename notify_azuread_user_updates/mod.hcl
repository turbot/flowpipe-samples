mod "notify_azuread_user_updates" {
  title       = "Jira integration for Azure AD users"
  description = " TO DO."

  require {
    mod "github.com/turbot/flowpipe-mod-azure" {
      version = "*"
      args = {
        subscription_id = var.subscription_id
        tenant_id       = var.tenant_id
        client_secret   = var.client_secret
        client_id       = var.client_id
      }
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "*"
      args = {
        token        = var.token
        user_email   = var.user_email
        api_base_url = var.api_base_url
      }
    }
  }
}
