mod "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."
  categories  = ["software development", "ai"]

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "v0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "v0.1.0"
    }
  }
}
