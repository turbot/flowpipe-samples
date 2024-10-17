mod "add_new_user_in_microsoft_office_365" {
  title         = "Add New User in Microsoft Office 365"
  description   = "Add a new user in Microsoft Office 365."
  documentation = file("./README.md")
  categories    = ["access management", "sample"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "1.0.0-rc-1.1"
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "1.0.0-rc.1"
    }
  }
}
