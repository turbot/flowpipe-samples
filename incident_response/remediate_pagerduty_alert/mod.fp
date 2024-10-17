mod "remediate_pagerduty_alert" {
  title         = "Remediate PagerDuty Alert"
  description   = "Take remediation actions based on the incident event type."
  documentation = file("./README.md")
  categories    = ["incident response"]

  require {
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "0.1.1-rc.1"
    }

    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "0.1.0-rc.1"
    }
  }
}

