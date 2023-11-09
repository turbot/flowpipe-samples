trigger "http" "aws_webhook" {
  title       = "AWS Webhook"
  description = "Webhook for AWS release events."

  pipeline = pipeline.router_pipeline
  args = {
    event        = self.request_headers["X-Github-Event"]
    request_body = jsondecode(self.request_body)
  }
}

pipeline "remediate_aws_alerts" {
  title       = ""
  description = ""

  param "api_base_url" {
    type        = string
    description = "API base URL for your Jira instance."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "API access token for authentication."
    default     = var.token
  }

  param "user_email" {
    type        = string
    description = "The email ID of the Jira user."
    default     = var.user_email
  }

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
    // default     = "project = test-turbot"
    // default     = "project = TUTORIAL"
  }

  param "summary" {
    type        = string
    description = "Summary for the issue."
    // default     = "Flowpipe Fireworks 2"
  }

  param "description" {
    type        = string
    description = "Description for the issue."
    // default     = "Description 2"
  }

  param "project_key" {
    type        = string
    description = "Project key for the new issue to be created."
    // default     = "SBT"
  }

  param "issue_type" {
    type        = string
    description = "Issue type for the new issue to be created."
    // default     = "Task"
  }

  step "pipeline" "search_issues_by_jql" {
    pipeline = jira.pipeline.search_issues_by_jql
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      jql_query    = param.jql_query
    }
  }

  step "pipeline" "create_issue" {
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      issue_type   = param.issue_type
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = param.summary
      description  = param.description
    }
  }

  step "pipeline" "update_issue" {
    pipeline = jira.pipeline.update_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = step.pipeline.search_issues_by_jql.output.issues.issues[0].id
      summary      = param.summary
      description  = param.description
    }
  }
}