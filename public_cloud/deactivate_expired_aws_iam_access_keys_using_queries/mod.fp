mod "deactivate_expired_aws_iam_access_keys_using_queries" {
  title         = "Deactivate Expired AWS IAM Access Keys Using Queries"
  description   = "Find expired keys using a query step, deactivate them, and send a notification."
  documentation = file("./README.md")
  categories    = ["public cloud", "security"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
  }
}
