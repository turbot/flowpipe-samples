mod "delete_mail_from_microsoft_office_365" {
  title         = "Delete Mail From Microsoft Office 365"
  description   = "Delete an email from a specified user's mailbox in Microsoft Office 365."
  documentation = file("./README.md")
  categories    = ["data management"]

  require {
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "1.0.0-rc.4"
    }
  }
}
