mod "remediate_pagerduty_alert" {
  title         = "Remediate PagerDuty Alert"
  description   = "Take remediation actions based on the incident event type."
  documentation = file("./README.md")
  categories    = ["incident response", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-pagerduty" {
      version = "^1"
    }

    mod "github.com/turbot/flowpipe-mod-reallyfreegeoip" {
      version = "^1"
    }
  }
}

