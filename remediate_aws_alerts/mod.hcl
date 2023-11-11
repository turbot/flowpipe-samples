mod "remediate_aws_alerts" {
  title       = "Enhancing AWS Security Posture with GuardDuty and Jira Integration"
  description = "Leverage GuardDuty to enrich AWS alerts, proactively respond to threats by isolating new connections, and manage security incidents seamlessly in Jira while reviewing and reapplying access restrictions."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "*"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }

    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "*"
      args = {
        api_base_url = var.api_base_url
        token        = var.token
        user_email   = var.user_email
      }
    }
  }
}
