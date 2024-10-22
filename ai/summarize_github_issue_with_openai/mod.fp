mod "summarize_github_issue_with_openai" {
  title         = "Summarize GitHub Issue with OpenAI"
  description   = "Summarize a GitHub issue with OpenAI."
  documentation = file("./README.md")
  categories    = ["software development", "ai", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "^1"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "^1"
    }
  }
}
