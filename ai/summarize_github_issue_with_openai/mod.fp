mod "summarize_github_issue_with_openai" {
  title         = "Summarize GitHub Issue with OpenAI"
  description   = "Summarize a GitHub issue with OpenAI."
  documentation = file("./README.md")
  categories    = ["software development", "ai"]

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "0.1.0"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.2.1"
    }
  }
}
