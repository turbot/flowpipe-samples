mod "aws_iam_user_in_groups" {
  title       = "AWS IAM User in Groups"
  description = "Create an issue in GitHub when AWS IAM User is in more than one Group."

  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "v0.0.2-dev-samples.3"
      args = {
        region            = var.aws_region
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "*"
      args = {
        token                = var.github_token
        repository_full_name = var.github_repository_full_name
      }
    }
  }
}
