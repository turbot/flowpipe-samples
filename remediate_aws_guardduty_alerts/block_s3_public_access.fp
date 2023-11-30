pipeline "block_s3_public_access" {

  param "jira_token" {
    type        = string
    description = "Jira API token."
    default = var.jira_token
  }

  param "aws_region" {
    type        = string
    description = "AWS region."
    default     = var.aws_region
  }

  param "aws_access_key_id" {
    type        = string
    description = "AWS access key id."
    default     = var.aws_access_key_id
  }

  param "aws_secret_access_key" {
    type        = string
    description = "AWS secret access key."
    default     = var.aws_secret_access_key
  }

  param "bucket" {
    type        = string
    description = "AWS S3 bucket name."
  }

  param "issue_id" {
    type        = string
    description = "Jira issue id."
  }

  param "jira_user_email" {
    type        = string
    description = "Jira user email."
    default     = var.jira_user_email
  }

  param "jira_api_base_url" {
    type        = string
    description = "API base URL."
    default     = var.jira_api_base_url
  }

  step "pipeline" "update_s3_bucket_public_access_block" {
    pipeline = aws.pipeline.update_s3_bucket_public_access_block
    args = {
      region                            = param.aws_region
      access_key_id                     = param.aws_access_key_id
      secret_access_key                 = param.aws_secret_access_key
      bucket                            = param.bucket
      public_access_block_configuration = "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.update_s3_bucket_public_access_block]
    pipeline   = jira.pipeline.add_comment
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      issue_id     = param.issue_id
      comment_text = "AWS S3 bucket public access blocked."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      issue_key    = param.issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      api_base_url  = param.jira_api_base_url
      token         = param.jira_token
      user_email    = param.jira_user_email
      issue_id      = param.issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}