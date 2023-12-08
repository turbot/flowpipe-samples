mod "delete_mail_from_microsoft_office_365" {
  title       = "Delete Email From Microsoft Office 365"
  description = "Delete an email from a specified user's mailbox in Microsoft Office 365."

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "v0.0.1-rc.14"
      args = {
        team_id = ""
      }
    }
  }
}
