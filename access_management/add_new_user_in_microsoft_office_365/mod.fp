mod "add_new_user_in_microsoft_office_365" {
  title         = "Add New User in Microsoft Office 365"
  description   = "Add a new user in Microsoft Office 365."
  documentation = file("./README.md")
  categories    = ["access management"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.18"
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.8"
    }
  }
}
