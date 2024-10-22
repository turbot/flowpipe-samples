mod "delete_mail_from_microsoft_office_365" {
  title         = "Delete Mail From Microsoft Office 365"
  description   = "Delete an email from a specified user's mailbox in Microsoft Office 365."
  documentation = file("./README.md")
  categories    = ["data management", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-teams" {
      version = "^1"
    }
  }
}
