mod "aws_iam_user_group_membership" {
  title       = "AWS IAM User Group Membership"
  description = "Create or Update a GitHub issue if an AWS IAM User belongs to multiple groups."
  categories  = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.4.0"
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.1.0"
    }
  }
}
