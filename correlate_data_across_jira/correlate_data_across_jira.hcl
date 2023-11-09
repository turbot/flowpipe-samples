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
  }

  param "project_key" {
    type        = string
    description = "Project key for the new issue to be created."
  }

  param "issue_type" {
    type        = string
    description = "Issue type for the new issue to be created."
  }

  param "assignee_id" {
    type        = string
    optional    = true
    description = "Assignee id."
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

  step "pipeline" "update_issue" {
    if = step.pipeline.search_issues_by_jql.output.issues != null

    for_each = step.pipeline.search_issues_by_jql.output.issues == null ? tomap({}) : { for issue in step.pipeline.search_issues_by_jql.output.issues : issue.id => issue }

    pipeline = jira.pipeline.update_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      user_email   = param.user_email
      issue_id     = each.key
      summary      = "This issue is updated by Flowpipe."
      description  = "This issue is related to issues ${join(", ", [for issue in step.pipeline.search_issues_by_jql.output.issues : "##${issue.id}"])}"
      priority     = "High"
      assignee_id  = param.assignee_id
    }
  }

  step "pipeline" "create_issue" {
    if       = step.pipeline.search_issues_by_jql.output.issues == null
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.api_base_url
      token        = param.token
      issue_type   = param.issue_type
      user_email   = param.user_email
      project_key  = param.project_key
      summary      = "This issue is created by Flowpipe."
      description  = "This issue is created by Flowpipe since search result was not matching."
      priority     = "High"
      assignee_id  = param.assignee_id
    }
  }
}
