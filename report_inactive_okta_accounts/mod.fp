mod "report_inactive_okta_accounts" {
  title       = "Report on Inactive Okta Accounts and Deactivate"
  description = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."

  require {
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "v0.0.2-rc.1"
      args = {
        api_token   = var.api_token
        okta_domain = var.okta_domain
      }
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.3"
      args = {
        token        = var.token
        user_email   = var.user_email
        api_base_url = var.api_base_url
        project_key  = var.project_key
      }
    }
  }

}
