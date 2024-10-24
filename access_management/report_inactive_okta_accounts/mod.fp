mod "report_inactive_okta_accounts" {
  title         = "Report on Inactive Okta Accounts and Deactivate"
  description   = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."
  documentation = file("./README.md")
  categories    = ["access management", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "^1"
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "^1"
    }
  }
}
