mod "remediate_pagerduty_alert" {
  title         = "Remediate PagerDuty Alert"
  description   = "Take remediation actions based on the incident event type."
  documentation = file("./README.md")
  categories    = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "v0.0.1-rc.13"
    }

    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "v0.0.1-rc.10"
    }
  }
}
