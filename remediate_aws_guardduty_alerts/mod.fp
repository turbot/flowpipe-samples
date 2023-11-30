mod "remediate_aws_guardduty_alerts" {
  title       = "Remediate AWS GuardDuty Alerts"
  description = "Remediate AWS GuardDuty Alerts pipeline responds to AWS GuardDuty alerts by creating Jira issues and executing remediation actions, such as blocking public access to S3 buckets or disassociating IAM roles from instances."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.5"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.3"
      args = {
        api_base_url = var.jira_api_base_url
        token        = var.jira_token
        user_email   = var.jira_user_email
        project_key  = var.jira_project_key
      }
    }
  }
}
