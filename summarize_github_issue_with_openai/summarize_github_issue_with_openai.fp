pipeline "summarize_github_issue_with_openai" {
  title       = "Summarize GitHub Issue with OpenAI"
  description = "Summarize a GitHub issue with OpenAI."

  tags = {
    type = "featured"
  }

  # OpenAI Parameters
  param "openai_cred" {
    type        = string
    description = "Name for OpenAI credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "model" {
    type        = string
    description = "ID of the model to use. See the [model endpoint compatibility](https://platform.openai.com/docs/models/model-endpoint-compatibility) table for details on which models work with the Chat API."
    default     = "gpt-3.5-turbo"
  }

  param "system_content" {
    type        = string
    description = "The role of the messages author. System in this case."
    default     = "You are a developer."
  }

  param "max_tokens" {
    type        = number
    description = "The maximum number of tokens to generate in the chat completion."
    default     = 50
  }

  param "temperature" {
    type        = number
    description = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic."
    default     = 1
  }

  # GitHub Parameters
  param "github_cred" {
    type        = string
    description = "Name for GitHub credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "issue_number" {
    type        = number
    description = "The number of the issue."
  }

  # Get a GitHub issue
  step "pipeline" "get_issue_by_number" {
    pipeline = github.pipeline.get_issue_by_number
    args = {
      cred         = param.github_cred
      issue_number = param.issue_number
    }
  }

  # Summarize the GitHub issue using OpenAI
  step "pipeline" "create_chat_completion" {
    pipeline = openai.pipeline.create_chat_completion
    args = {
      cred           = param.openai_cred
      max_tokens     = param.max_tokens
      model          = param.model
      system_content = param.system_content
      temperature    = param.temperature
      user_content   = "Summarize the issue - ${step.pipeline.get_issue_by_number.output.issue.body}"
    }
  }

  output "openai_responses" {
    value = step.pipeline.create_chat_completion.output
  }
}
