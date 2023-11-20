mod "remediate_pagerduty_alert" {
  title       = "Remediate PagerDuty Alert"
  description = "Remediate PagerDuty alert."

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "v0.0.1-rc.4"
      args = {
        api_key = var.pagerduty_api_token
      }
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "v0.0.1-rc.1"
    }
  }
}
