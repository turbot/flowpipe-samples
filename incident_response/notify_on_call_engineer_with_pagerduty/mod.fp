mod "notify_on_call_engineer_with_pagerduty" {
  title         = "Notify On-Call Engineer With PagerDuty"
  description   = "Notify an on-call engineer with PagerDuty."
  documentation = file("./README.md")
  categories    = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "0.1.1-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.3.0-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "1.0.0-rc.1"
    }
  }
}
