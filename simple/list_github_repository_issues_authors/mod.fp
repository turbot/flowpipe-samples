mod "list_github_repository_issues_authors" {
  title       = "List GitHub repository issues authors"
  description = "Lists the authors of the issues in a GitHub repository."

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.3"
      args = {
        access_token         = var.github_access_token
        repository_full_name = var.github_repository_full_name
      }
    }
  }
}
