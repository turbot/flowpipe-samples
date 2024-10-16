mod "summarize_github_issue_with_openai" {
  title         = "Summarize GitHub Issue with OpenAI"
  description   = "Summarize a GitHub issue with OpenAI."
  documentation = file("./README.md")
  categories    = ["software development", "ai"]

  require {
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "0.2.0-rc.2"
    }
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "v0.1.0-rc.1"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "0.3.0-rc.1"
    }
  }
}
