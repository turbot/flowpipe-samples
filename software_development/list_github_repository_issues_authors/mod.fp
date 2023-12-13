mod "list_github_repository_issues_authors" {
  title       = "List GitHub Repository Issues Authors"
  description = "Lists the authors of the issues in a GitHub repository."
  documentation = file("./README.md")
  categories  = ["software development"]

  opengraph {
    title       = "List GitHub Repository Issues Authors"
    description = "Lists the authors of the issues in a GitHub repository."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.1.0"
      args = {
        repository_full_name = var.github_repository_full_name
      }
    }
  }
}
