pipeline "list_github_repository_issues_authors" {
  title       = "List GitHub Repository Issues Authors"
  description = "Lists the authors of the issues in a GitHub repository."

  param "github_cred" {
    type        = string
    description = "Name for GitHub credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "github_repository_full_name" {
    type        = string
    description = "The GitHub repository full name."
    default     = var.github_repository_full_name
  }

  step "pipeline" "list_issues" {
    pipeline = github.pipeline.list_issues
    args = {
      cred   = param.github_cred
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
