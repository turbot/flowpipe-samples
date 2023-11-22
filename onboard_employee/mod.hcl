mod "onboard_employee" {
  title       = "Onboard Employee"
  description = "Onboard an Employee onto multiple platforms."

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.2"
      args = {
        access_token         = var.github_access_token
        repository_full_name = var.github_repository_full_name
      }
    }
    mod "github.com/turbot/flowpipe-mod-zendesk" {
      version = "v0.0.1-rc.1"
      args = {
        api_token  = var.zendesk_api_token
        user_email = var.zendesk_user_email
        subdomain  = var.zendesk_subdomain
      }
    }
    mod "github.com/turbot/flowpipe-mod-gitlab" {
      version = "v0.0.1-rc.1"
      args = {
        access_token = var.gitlab_access_token
      }
    }
  }
}
