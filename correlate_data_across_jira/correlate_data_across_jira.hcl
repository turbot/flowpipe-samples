pipeline "correlate_data_across_jira" {
  title       = "Correlate data across Jira"
  description = "Search for Jira issues, update issue if found, create a jira issue if not found."

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
    default     = "project = test-turbot"
  }

  step "pipeline" "search_issues_by_JQL" {
    pipeline = jira.pipeline.search_issues_by_JQL
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      jql_query    = param.jql_query
    }
  }

  output "issues" {
    description = "List of issues matching the JQL query."
    value       = step.pipeline.search_issues_by_JQL.response_body
  }

  // step "pipeline" "update_issue" {
  //   when = "eq(length(pipeline.search_issues_by_JQL.issues), 1)"
  //   pipeline = jira.pipeline.update_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     issue_id     = pipeline.search_issues_by_JQL.issues[0].id
  //     issue_key    = pipeline.search_issues_by_JQL.issues[0].key
  //     summary      = "Updated summary"
  //     description  = "Updated description"
  //   }
  // }

  // step "pipeline" "create_issue" {
  //   when = "eq(length(pipeline.search_issues_by_JQL.issues), 0)"
  //   pipeline = jira.pipeline.create_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     project_key  = "TEST"
  //     summary      = "Created summary"
  //     description  = "Created description"
  //   }
  // }

}