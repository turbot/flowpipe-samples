pipeline "list_github_repository_issues_authors" {
  title       = "List GitHub Repository Issues Authors"
  description = "Lists the authors of the issues in a GitHub repository."

  param "github_cred" {
    type        = string
    description = "Name for GitHub credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "repository_owner" {
    type        = string
    description = "The organization or user name."
  }

  param "repository_name" {
    type        = string
    description = "The name of the repository."
  }

  step "pipeline" "list_issues" {
    pipeline = github.pipeline.list_issues
    args = {
      cred             = param.github_cred
      repository_owner = param.repository_owner
      repository_name  = param.repository_name
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
