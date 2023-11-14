mod "deactivate_expired_aws_iam_access_keys" {
  title       = "Deactivate expired AWS IAM keys"
  description = "Deactivates AWS IAM keys that have been active for a certain period of time."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.2-dev-samples.3"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }

    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.3"
      args = {
        token   = var.slack_token
        channel = var.slack_channel
      }
    }
  }

}