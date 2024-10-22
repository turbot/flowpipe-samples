mod "deactivate_expired_aws_iam_access_keys_with_approval" {
  title         = "Deactivate Expired AWS IAM Access Keys with Approval"
  description   = "Find expired AWS IAM access keys and deactivate them (with approval) or leave them active and send an alert."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "^1"
    }
  }

}
