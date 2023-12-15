mod "list_github_repository_issues_authors" {
  title       = "List GitHub Repository Issues Authors"
  description = "Lists the authors of the issues in a GitHub repository."
  documentation = file("./README.md")
  categories  = ["software development"]

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "0.1.0"
    }
  }
}
