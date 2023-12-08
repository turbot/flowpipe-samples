pipeline "summarize_a_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  param "openapi_api_key" {
    type        = string
    description = "The OpenAI API key to authenticate to the OpenAI APIs, e.g., `sk-a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16q17r18s19`. Please see https://platform.openai.com/account/api-keys for more information."
    default     = var.openapi_api_key
  }

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
    pipeline = openai.pipeline.send_request
    args = {
      system_content = param.system_content
      user_content   = "Summarize the issue - ${step.pipeline.get_issue_by_number.output.issue.body}"
    }
  }

  output "openai_responses" {
    value = step.pipeline.send_request.output
  }
}
