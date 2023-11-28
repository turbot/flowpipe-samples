mod "remediate_aws_guardduty_alerts" {
  title       = "Remediate AWS GuardDuty Alerts"
  description = "Remediate AWS GuardDuty Alerts pipeline responds to AWS GuardDuty alerts by creating Jira issues and executing remediation actions, such as blocking public access to S3 buckets or disassociating IAM roles from instances."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "*"
      args = {
        region            = var.region
        access_key_id     = var.access_key_id
        secret_access_key = var.secret_access_key
      }
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "*"
      args = {
        api_base_url = var.api_base_url
        token        = var.token
        user_email   = var.user_email
        project_key  = var.project_key
      }
    }
  }
}
