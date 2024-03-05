mod "deactivate_expired_aws_iam_access_keys_with_approval" {
  title         = "Deactivate Expired AWS IAM Access Keys with Approval"
  description   = "Find expired AWS IAM access keys and deactivate them (with approval) or escalate with a notification."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
  }

}
