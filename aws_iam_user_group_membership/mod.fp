mod "aws_iam_user_group_membership" {
  title       = "AWS IAM User Group Membership"
  description = "Create or Update a GitHub issue if an AWS IAM User belongs to multiple groups."
  categories  = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.18"
      args = {
        region = var.aws_region
      }
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.9"
      args = {
        repository_full_name = var.github_repository_full_name
      }
    }
  }
}
