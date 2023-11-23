mod "aws_iam_user_group_membership" {
  title       = "AWS IAM User Group Membership"
  description = "Create or Update a GitHub issue if an AWS IAM User belongs to multiple groups."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.1-rc.3"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.2"
      args = {
        access_token         = var.github_token
        repository_full_name = var.github_repository_full_name
      }
    }
  }
}
