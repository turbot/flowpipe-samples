pipeline "block_s3_public_access" {

  param "token" {
    type        = string
    description = "API access token"
    # TODO: Add once supported
    # sensitive  = true
    default = var.token
  }

  param "region" {
    type        = string
    description = "AWS region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "AWS access key id."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "AWS secret access key."
    default     = var.secret_access_key
  }

  param "bucket" {
    type        = string
    description = "S3 bucket name."
  }

  param "issue_id" {
    type        = string
    description = "Jira issue id."
  }

  param "user_email" {
    type        = string
    description = "Email-id of the user."
    default     = var.user_email
  }

  param "api_base_url" {
    type        = string
    description = "API base URL."
    default     = var.api_base_url
  }

  param "project_key" {
    type        = string
    description = "The key identifying the project."
    default     = var.project_key
  }

  step "pipeline" "update_s3_bucket_public_access_block" {
    pipeline = aws.pipeline.update_s3_bucket_public_access_block
    args = {
      region                            = param.region
      access_key_id                     = param.access_key_id
      secret_access_key                 = param.secret_access_key
      bucket                            = param.bucket
      public_access_block_configuration = "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.update_s3_bucket_public_access_block]
    pipeline   = jira.pipeline.add_comment
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = param.issue_id
      comment_text = "S3 bucket public access blocked."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_key    = param.issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      api_base_url  = param.api_base_url
      token         = param.token
      user_email    = param.user_email
      issue_id      = param.issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}