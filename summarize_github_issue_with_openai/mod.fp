mod "summarize_github_issue_with_openai" {
  title         = "Summarize GitHub Issue with OpenAI"
  description   = "Summarize a GitHub issue with OpenAI."
  documentation = file("./README.md")
  categories    = ["ai"]

  require {
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "v0.0.1-rc.6"
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.8"
      args = {
        repository_full_name = var.repository_full_name
      }
    }
  }
}
