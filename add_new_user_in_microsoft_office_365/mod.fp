mod "add_new_user_in_microsoft_office_365" {
  title       = "Add New User in Microsoft Office 365"
  description = "Add a new user in Microsoft Office 365."
  categories  = ["access management"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.15"
      args = {
        team_id = var.team_id
      }
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.6"
    }
  }
}