mod "notify_on_call_engineer_with_pagerduty" {
  title         = "Notify On-Call Engineer With PagerDuty"
  description   = "Notify an on-call engineer with PagerDuty."
  documentation = file("./README.md")
  categories    = ["incident response", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "^1"
    }
  }
}
