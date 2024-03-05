mod "deactivate_expired_aws_iam_access_keys" {
  title         = "Deactivate Expired AWS IAM Access Keys"
  description   = "Deactivate AWS IAM access keys that have been active for a certain period of time."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.2.1"
    }
  }

}
