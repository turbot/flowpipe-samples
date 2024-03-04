mod "notify_on_call_engineer_with_pagerduty" {
  title         = "Notify On-Call Engineer With PagerDuty"
  description   = "Notify an on-call engineer with PagerDuty."
  documentation = file("./README.md")
  categories    = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.2.1"
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "0.1.0"
    }
  }
}
