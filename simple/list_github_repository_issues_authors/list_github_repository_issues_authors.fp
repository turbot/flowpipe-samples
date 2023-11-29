pipeline "list_github_repository_issues_authors" {
  title       = "List GitHub repository issues authors"
  description = "Lists the authors of the issues in a GitHub repository."

  step "pipeline" "list_issues" {
    pipeline = github.pipeline.list_issues
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
