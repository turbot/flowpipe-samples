mod "deactivate_expired_aws_iam_access_keys_with_approval" {
  title         = "Deactivate Expired AWS IAM Access Keys with Approval"
  description   = "Deactivate AWS IAM access keys that have been created for a certain period of time."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.0"
    }
  }

}
