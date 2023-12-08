mod "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  require {
    mod "github.com/turbot/flowpipe-mod-openai" {
      version = "v0.0.1-rc.1"
      args = {
        api_key = var.openapi_api_key
      }
    }
    mod "github.com/turbot/flowpipe-mod-github" {
      version = "v0.0.1-rc.5"
      args = {
        repository_full_name = var.repository_full_name
      }
    }
  }
}
