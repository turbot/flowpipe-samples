pipeline "list_github_repository_issues_authors" {
  title       = "List GitHub Repository Issues Authors"
  description = "Lists the authors of the issues in a GitHub repository."

  param "conn" {
    type        = connection.github
    description = "Name of Github connection to use. If not provided, the default Github connection will be used."
    default     = connection.github.default
  }

  param "repository_owner" {
    type        = string
    description = "The organization or user name."
  }

  param "repository_name" {
    type        = string
    description = "The name of the repository."
  }

  param "issue_state" {
    type        = string
    description = "The possible states of an issue. Allowed values are OPEN and CLOSED."
  }

  step "pipeline" "list_issues" {
    pipeline = github.pipeline.list_issues
    args = {
      conn             = param.conn
      repository_owner = param.repository_owner
      repository_name  = param.repository_name
      issue_state      = param.issue_state
    }
  }

  step "transform" "issues_authors_list" {
    value = sort(distinct(step.pipeline.list_issues.output.issues[*].author.login))
  }

  step "transform" "issues_authors_string" {
    value = join(", ", step.transform.issues_authors_list.value)
  }

  output "unique_authors" {
    description = "Lists the authors of the issues in a GitHub repository."
    value       = "Issue authors: ${step.transform.issues_authors_string.value}"
  }
}
