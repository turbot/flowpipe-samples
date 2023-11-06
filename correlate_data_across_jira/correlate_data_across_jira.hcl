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
    // default = "project = azuread-user-offboarding"
  }

  param "summary" {
    type        = string
    description = "Summary for the issue."
    default     = "Summary"
  }

  param "description" {
    type        = string
    description = "Description for the issue."
    default     = "Description"
  }

  param "project_key" {
    type        = string
    description = "Project key for the new issue to be created."
    default     = "SBT"
  }

  step "pipeline" "search_issues_by_jql" {
    pipeline = jira.pipeline.search_issues_by_jql
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      jql_query    = param.jql_query
    }
    error {
      ignore = true
    }
  }

  output "test" {
    description = "List of issues matching the JQL query."
    value = !is_error(step.pipeline.search_issues_by_jql.output) ? "pass" : "fail"
  }
  
  // step "pipeline" "update_issue" {
  //   // if       = length(pipeline.search_issues_by_jql.output.issues.issues) == 1
  //   pipeline = jira.pipeline.update_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     issue_id     = pipeline.search_issues_by_jql.output.issues.issues[0].id
  //     issue_key    = pipeline.search_issues_by_jql.output.issues.issues[0].key
  //     summary      = param.summary
  //     description  = param.description
  //   }
  // }

  //   step "pipeline" "create_issue" {
  //   if = length(step.pipeline.search_issues_by_jql.output.issues.issues) == 0
  //   pipeline = jira.pipeline.create_issue
  //   args = {
  //     api_base_url = param.api_base_url
  //     token        = param.token
  //     user_email   = param.user_email
  //     project_key  = param.project_key
  //     summary      = param.summary
  //     description  = param.description
  //   }
  // }

}