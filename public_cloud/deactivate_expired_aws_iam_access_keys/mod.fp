mod "deactivate_expired_aws_iam_access_keys" {
  title       = "Deactivate expired AWS IAM keys"
  description = "Deactivates AWS IAM keys that have been active for a certain period of time."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "0.1.0"
    }

    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.1.0"
    }
  }

}
