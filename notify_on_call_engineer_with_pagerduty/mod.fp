mod "notify_on_call_engineer_with_pagerduty" {
  title       = "Notify On-Call Engineer With PagerDuty"
  description = "Notify an on-call engineer with PagerDuty."

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "v0.0.1-rc.7"
      args = {
        api_key = var.pagerduty_api_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.1"
      args = {
        token = var.slack_api_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-sendgrid" {
      version = "v0.0.3"
      args = {
        api_key = var.sendgrid_api_key
      }
    }
  }
}
