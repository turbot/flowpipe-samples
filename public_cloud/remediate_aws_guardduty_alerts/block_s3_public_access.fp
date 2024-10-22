pipeline "block_s3_public_access" {

  param "jira_conn" {
    type        = connection.jira
    description = "Name for Jira connections to use. If not provided, the default connection will be used."
    default     = var.jira_conn
  }

  param "aws_conn" {
    type        = connection.aws
    description = "Name for AWS connection to use. If not provided, the default connection will be used."
    default     = var.aws_conn
  }

  param "aws_region" {
    type        = string
    description = "AWS region."
    default     = var.aws_region
  }

  param "aws_bucket" {
    type        = string
    description = "AWS S3 bucket name."
  }

  param "jira_issue_id" {
    type        = string
    description = "Jira issue id."
  }

  step "pipeline" "put_s3_bucket_public_access_block" {
    pipeline = aws.pipeline.put_s3_bucket_public_access_block
    args = {
      conn                    = param.aws_conn
      region                  = param.aws_region
      bucket                  = param.aws_bucket
      block_public_acls       = true
      ignore_public_acls      = true
      block_public_policy     = true
      restrict_public_buckets = true
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.put_s3_bucket_public_access_block]
    pipeline   = jira.pipeline.add_comment
    args = {
      conn         = param.jira_conn
      issue_id     = param.jira_issue_id
      comment_text = "AWS S3 bucket public access blocked."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      conn      = param.jira_conn
      issue_key = param.jira_issue_id
    }
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.pipeline.get_issue_transitions]
    pipeline   = jira.pipeline.transition_issue
    args = {
      conn          = param.jira_conn
      issue_id      = param.jira_issue_id
      transition_id = tonumber([for transition in step.pipeline.get_issue_transitions.output.transitions : transition.id if transition.name == "Done"][0])
    }
  }

}
