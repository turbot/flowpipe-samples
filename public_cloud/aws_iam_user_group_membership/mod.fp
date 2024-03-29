mod "aws_iam_user_group_membership" {
  title         = "AWS IAM User Group Membership"
  description   = "Create or Update a GitHub issue if an AWS IAM User belongs to multiple groups."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = ">=0.1.1"
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "0.1.0"
    }
  }
}
