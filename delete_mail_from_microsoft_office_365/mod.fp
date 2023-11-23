mod "delete_mail_from_microsoft_office_365" {
  title       = "Delete Email From Microsoft Office 365"
  description = "Delete an email from a specified user's mailbox in Microsoft Office 365."

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.9"
      args = {
        access_token = var.teams_access_token
      }
    }
  }
}
