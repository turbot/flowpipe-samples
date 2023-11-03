mod "deactivate_longstanding_aws_iam_access_keys" {
  title       = "Deactivate longstanding AWS IAM keys"
  description = "Deactivates AWS IAM keys that have been active for a certain period of time."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.2-dev-samples.2"
      args = {
        region                = var.aws_region
        access_key_id         = var.aws_access_key_id
        secret_access_key     = var.aws_secret_access_key
      }
    }
  }

}
