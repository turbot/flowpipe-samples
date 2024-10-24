mod "remediate_aws_guardduty_alerts" {
  title         = "Remediate AWS GuardDuty Alerts"
  description   = "Remediate AWS GuardDuty Alerts pipeline responds to AWS GuardDuty alerts by creating Jira issues and executing remediation actions, such as blocking public access to S3 buckets or disassociating IAM roles from instances."
  documentation = file("./README.md")
  categories    = ["public cloud", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "^1"
    }
  }
}
