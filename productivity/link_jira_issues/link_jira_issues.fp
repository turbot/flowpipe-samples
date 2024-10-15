pipeline "link_jira_issues" {
  title       = "Link Issues Across Jira"
  description = "Search for Jira issues, update description, summary, priority, and assignee in an issue if found, create a Jira issue if not found."

  param "jira_conn" {
    type        = connection.jira
    description = "Name for Jira connections to use. If not provided, the default connection will be used."
    default     = connection.jira.default
  }

  param "jira_jql_query" {
    type        = string
    description = "JQL query for searching issues."
  }

  param "jira_project_key" {
    type        = string
    description = "Project key for the new issue to be created."
  }

  param "jira_issue_type" {
    type        = string
    description = "Issue type for the new issue to be created."
  }

  step "pipeline" "search_issues_by_jql" {
    pipeline = jira.pipeline.search_issues_by_jql
    args = {
      jql_query = param.jira_jql_query
    }
  }

  step "pipeline" "update_issues" {
    for_each = { for issue in step.pipeline.search_issues_by_jql.output.issues : issue.id => issue }
    pipeline = jira.pipeline.update_issue
    args = {
      conn        = param.jira_conn
      issue_id    = each.key
      summary     = "${each.value.fields.summary} This issue is updated by Flowpipe."
      description = "${each.value.fields.summary} This issue is related to issues ${join(", ", [for issue in step.pipeline.search_issues_by_jql.output.issues : "##${issue.id}"])}"
    }
  }

  step "pipeline" "create_issue" {
    if       = length(step.pipeline.search_issues_by_jql.output.issues) == 0
    pipeline = jira.pipeline.create_issue
    args = {
      conn        = param.jira_conn
      issue_type  = param.jira_issue_type
      project_key = param.jira_project_key
      summary     = "This issue was created by Flowpipe since there were no matches for the search query ${param.jira_jql_query}"
      description = "New issue related to ${param.jira_jql_query} query."
    }
  }

  output "output" {
    value = length(step.pipeline.search_issues_by_jql.output.issues) == 0 ? !is_error(step.pipeline.create_issue)? "Could not find matches for the search query ${param.jira_jql_query}, new issue got created with issue id as ${step.pipeline.create_issue.output.issue.id}" : "Could not find matches for the search query ${param.jira_jql_query}, issue creation failed!!" : !is_error(step.pipeline.update_issues)? "Found matches for the search query ${param.jira_jql_query}, issues got updated" : "Found matches for the search query ${param.jira_jql_query} but could not update issues"
  }
}
