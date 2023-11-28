mod "notify_new_aws_iam_access_keys" {
  title       = "AWS IAM Access Keys"
  description = "Trigger to find new AWS IAM Access Keys."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.3"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.0.1-rc.2"
      args = {
        token = var.slack_token
      }
    }
  }
}
