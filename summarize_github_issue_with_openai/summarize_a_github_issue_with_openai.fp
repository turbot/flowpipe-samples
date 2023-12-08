pipeline "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  param "issue_number" {
    type        = number
    description = "The number of the issue."
  }

  param "system_content" {
    type        = string
    description = "The role of the messages author. System in this case."
    default     = "You are a developer."
  }

  # Get a GitHub issue
  step "pipeline" "get_issue_by_number" {
    pipeline = github.pipeline.get_issue_by_number
    args = {
      issue_number = param.issue_number
    }
  }

  # Summarize the GitHub issue using OpenAI
  step "pipeline" "send_request" {
    depends_on = [step.pipeline.get_issue_by_number]
    pipeline   = openai.pipeline.send_request
    args = {
      system_content = param.system_content
      user_content   = "Summarize the issue - ${step.pipeline.get_issue_by_number.output.issue.body}"
    }
  }

  output "openai_responses" {
    value = step.pipeline.send_request.output
  }
}
