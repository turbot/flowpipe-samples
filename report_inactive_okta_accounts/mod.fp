mod "report_inactive_okta_accounts" {
  title         = "Report on Inactive Okta Accounts and Deactivate"
  description   = "Routinely scan Okta environments for potential inactive accounts and deactivate accounts."
  documentation = file("./README.md")
  categories    = ["access management"]

  require {
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "v0.0.1-rc.5"
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.8"
    }
  }
}
