mod "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Notify an on-call engineer with PagerDuty."
  categories  = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "v0.0.1-rc.10"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.1-rc.4"
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "v0.0.1-rc.2"
    }
  }
}
