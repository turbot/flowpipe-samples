pipeline "link_jira_issues" {
  title       = "Link Issues Across Jira"
  description = "Search for Jira issues, update description, summary, priority, and assignee in an issue if found, create a Jira issue if not found."

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
  }

  param "jira_project_key" {
    type        = string
    description = "Project key for the new issue to be created."
  }

  param "issue_type" {
    type        = string
    description = "Issue type for the new issue to be created."
  }

  step "pipeline" "search_issues_by_jql" {
    pipeline = jira.pipeline.search_issues_by_jql
    args = {
      jql_query    = param.jql_query
    }
  }

  step "pipeline" "update_issues" {
    for_each = { for issue in step.pipeline.search_issues_by_jql.output.issues : issue.id => issue }
    pipeline = jira.pipeline.update_issue
    args = {
      issue_id     = each.key
      summary      = "${each.value.fields.summary} This issue is updated by Flowpipe."
      description  = "${each.value.fields.summary} This issue is related to issues ${join(", ", [for issue in step.pipeline.search_issues_by_jql.output.issues : "##${issue.id}"])}"
    }
  }

  step "pipeline" "create_issue" {
    if       = length(step.pipeline.search_issues_by_jql.output.issues) == 0
    pipeline = jira.pipeline.create_issue
    args = {
      issue_type   = param.issue_type
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
