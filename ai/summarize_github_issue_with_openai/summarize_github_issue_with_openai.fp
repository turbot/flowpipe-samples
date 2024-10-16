pipeline "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  param "github_conn" {
    type        = connection.github
    description = "Name of Github connection to use. If not provided, the default Github connection will be used."
    default     = connection.github.default
  }

  param "slack_conn" {
    type        = connection.slack
    description = "Name of Slack connection to use. If not provided, the default Slack connection will be used."
    default     = connection.slack.default
  }

  param "openai_conn" {
    type        = connection.openai
    description = "Name of OpenAI connection to use. If not provided, the default OpenAI connection will be used."
    default     = connection.openai.default
  }

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
  }

  param "openai_model" {
    type        = string
    description = "ID of the model to use. See the [model endpoint compatibility](https://platform.openai.com/docs/models/model-endpoint-compatibility) table for details on which models work with the Chat API."
  }

  param "openai_max_tokens" {
    type        = number
    description = "The maximum number of tokens to generate in the chat completion."
  }

  param "openai_temperature" {
    type        = number
    description = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic."
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
  }

  # Get a GitHub issue
  step "pipeline" "get_issue_by_number" {
    pipeline = github.pipeline.get_issue_by_number
    args = {
      conn             = param.github_conn
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
      conn           = param.openai_conn
      model          = param.openai_model
      system_content = param.openai_system_content
      temperature    = param.openai_temperature
      max_tokens     = param.openai_max_tokens
      user_content   = "Summarize this issue: ${step.pipeline.get_issue_by_number.output.issue.title} - ${step.pipeline.get_issue_by_number.output.issue.body}"
    }
  }

  # Send to Slack
  step "pipeline" "post_message" {
    depends_on = [step.pipeline.create_chat_completion]
    pipeline   = slack.pipeline.post_message
    args = {
      conn    = param.slack_conn
      channel = param.slack_channel
      text    = "Summary for ${param.github_repository_owner}/${param.github_repository_name} issue #${param.github_issue_number}: ${step.pipeline.create_chat_completion.output.choices[0].message.content}"
    }
  }

  output "openai_response" {
    value = step.pipeline.create_chat_completion.output
  }
}
