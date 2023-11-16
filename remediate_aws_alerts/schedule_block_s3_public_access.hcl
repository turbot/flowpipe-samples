//  Schedule Trigger
trigger "schedule" "schedule_block_s3_public_access" {
  description = "A cron that checks xxxxx."
  schedule    = "* * * * *"
  // schedule    = "*/5 * * * *" // Run every 5 min
  pipeline = pipeline.block_s3_public_access
}

pipeline "block_s3_public_access" {

  param "token" {
    type        = string
    description = "API access token"
    # TODO: Add once supported
    # sensitive  = true
    default = var.token
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

  step "pipeline" "list_issues" {
    pipeline = jira.pipeline.list_issues
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      project_key  = param.project_key
    }
  }

  step "pipeline" "update_s3_bucket_public_access_block" {
    depends_on = [step.pipeline.list_issues]
    for_each   = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Block") && each_issue.fields.status.name != "Done" } : tomap({})
    pipeline   = aws.pipeline.update_s3_bucket_public_access_block
    args = {
      region                            = var.region
      access_key_id                     = var.access_key_id
      secret_access_key                 = var.secret_access_key
      bucket                            = split(" ", each.value.fields.summary)[1]
      public_access_block_configuration = "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    }
  }

  step "pipeline" "add_comment" {
    depends_on = [step.pipeline.update_s3_bucket_public_access_block]
    for_each   = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Block") && each_issue.fields.status.name != "Done" } : tomap({})
    pipeline   = jira.pipeline.add_comment
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = each.value.id
      comment_text = "S3 bucket public access blocked."
    }
  }

  step "pipeline" "get_issue_transitions" {
    depends_on = [step.pipeline.add_comment]
    for_each   = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Block") && each_issue.fields.status.name != "Done" } : tomap({})
    pipeline   = jira.pipeline.get_issue_transitions
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_key    = each.value.id
    }
  }

  step "echo" "issue_transition_id" {
    depends_on = [step.pipeline.get_issue_transitions]
    json = [for issue in step.pipeline.list_issues.output.issues.issues : {
      issue_key = issue.key
      done_transition_id = [for each_transition in flatten([for t in values(step.pipeline.get_issue_transitions): t.output.transitions ]) : each_transition.id if each_transition.name == "Done"][0]
    } if strcontains(issue.fields.summary, "Block") && issue.fields.status.name != "Done"]
  }

  step "pipeline" "transition_issue" {
    depends_on = [step.echo.issue_transition_id]
    for_each   = { for issue_transition in step.echo.issue_transition_id.json : issue_transition.issue_key => issue_transition.done_transition_id}
    pipeline   = jira.pipeline.transition_issue
    args = {
      api_base_url  = param.api_base_url
      token         = param.token
      user_email    = param.user_email
      issue_id      = each.key
      transition_id = tonumber(each.value)
    }
  }
  output "issue_transition_id" {
    value = step.echo.issue_transition_id.json
  }
}