pipeline "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  param "github_repository_owner" {
    type        = string
    description = "The organization or user name."
  }

  param "github_repository_name" {
    type        = string
    description = "The name of the repository."
  }

  param "github_issue_number" {
    type        = number
    description = "The number of the issue."
  }

  param "openai_system_content" {
    type        = string
    description = "The role of the messages author. System in this case."
    default     = "You are a developer."
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
  }

  # Get a GitHub issue
  step "pipeline" "get_issue_by_number" {
    pipeline = github.pipeline.get_issue_by_number
    args = {
      repository_owner = param.github_repository_owner
      repository_name  = param.github_repository_name
      issue_number     = param.github_issue_number
    }
  }

  # Summarize the GitHub issue using OpenAI
  step "pipeline" "create_chat_completion" {
    depends_on = [step.pipeline.get_issue_by_number]
    pipeline   = openai.pipeline.create_chat_completion
    args = {
      system_content = param.openai_system_content
      user_content   = "Summarize this issue: ${step.pipeline.get_issue_by_number.output.issue.title} - ${step.pipeline.get_issue_by_number.output.issue.body}"
    }
  }

  # Send to Slack
  step "pipeline" "post_message" {
    depends_on = [step.pipeline.create_chat_completion]
    pipeline   = slack.pipeline.post_message
    args = {
      channel = param.slack_channel
      text    = "Summary for ${param.github_repository_owner}/${param.github_repository_name} issue #${param.github_issue_number}: ${step.pipeline.create_chat_completion.output.choices[0].message.content}"
    }
  }

  output "openai_response" {
    value = step.pipeline.create_chat_completion.output
  }
}
