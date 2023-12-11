mod "remediate_pagerduty_alert" {
  title       = "Remediate PagerDuty Alert"
  description = "Remediate PagerDuty alert."
  categories  = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "v0.0.1-rc.10"
    }
    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "v0.0.1-rc.5"
    }
  }
}
