mod "add_new_user_in_microsoft_teams" {
  title       = "Add New User in Microsoft Teams"
  description = "Add a new user in Microsoft Teams."

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.7"
      args = {
        access_token = var.teams_access_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.2"
      args = {
        token        = var.jira_token
        user_email   = var.jira_user_email
        api_base_url = var.jira_api_base_url
        project_key  = var.jira_project_key
      }
    }
  }
}
