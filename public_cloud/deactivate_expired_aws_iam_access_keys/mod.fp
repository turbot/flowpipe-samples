mod "deactivate_expired_aws_iam_access_keys" {
  title       = "Deactivate expired AWS IAM keys"
  description = "Deactivates AWS IAM keys that have been active for a certain period of time."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.2.0"
    }

    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.1.0"
    }
  }

}
