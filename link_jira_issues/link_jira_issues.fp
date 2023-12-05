pipeline "link_jira_issues" {
  title       = "Link Issues Across Jira"
  description = "Search for Jira issues, update description, summary, priority, and assignee in an issue if found, create a Jira issue if not found."

  param "jira_api_base_url" {
    type        = string
    description = "API base URL for your Jira instance."
    default     = var.jira_api_base_url
  }

  param "jira_token" {
    type        = string
    description = "API access token for authentication."
    default     = var.jira_token
  }

  param "jira_user_email" {
    type        = string
    description = "The email of the Jira user."
    default     = var.jira_user_email
  }

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
  }

  param "jira_project_key" {
    type        = string
    description = "Project key for the new issue to be created."
    default     = var.jira_project_key
  }

  param "issue_type" {
    type        = string
    description = "Issue type for the new issue to be created."
  }

  step "pipeline" "search_issues_by_jql" {
    pipeline = jira.pipeline.search_issues_by_jql
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      jql_query    = param.jql_query
    }
  }

  step "pipeline" "update_issues" {
    for_each = step.pipeline.search_issues_by_jql.output.issues == null ? tomap({}) : { for issue in step.pipeline.search_issues_by_jql.output.issues : issue.id => issue }
    pipeline = jira.pipeline.update_issue
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      user_email   = param.jira_user_email
      issue_id     = each.key
      summary      = "${each.value.fields.summary} This issue is updated by Flowpipe."
      description  = "${each.value.fields.summary} This issue is related to issues ${join(", ", [for issue in step.pipeline.search_issues_by_jql.output.issues : "##${issue.id}"])}"
    }
  }

  step "pipeline" "create_issue" {
    if       = step.pipeline.search_issues_by_jql.output.issues == null
    pipeline = jira.pipeline.create_issue
    args = {
      api_base_url = param.jira_api_base_url
      token        = param.jira_token
      issue_type   = param.issue_type
      user_email   = param.jira_user_email
      project_key  = param.jira_project_key
      summary      = "This issue was created by Flowpipe since there were no matches for the search query ${param.jql_query}"
      description  = "New issue related to ${param.jql_query} query."
    }
  }

  output "found_issues" {
    value = step.pipeline.search_issues_by_jql.output.issues
  }

  output "created_issue" {
    value = step.pipeline.create_issue
  }

  output "updated_issues" {
    value = step.pipeline.update_issues
  }
}
