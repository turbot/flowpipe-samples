mod "aws_iam_user_group_membership" {
  title         = "AWS IAM User Group Membership"
  description   = "Create or Update a GitHub issue if an AWS IAM User belongs to multiple groups."
  documentation = file("./README.md")
  categories    = ["public cloud", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "^1"
    }
  }
}
