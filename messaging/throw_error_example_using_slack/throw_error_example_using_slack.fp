pipeline "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."

  tags = {
    type = "featured"
  }

  param "slack_cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "slack_channel" {
    type        = string
    description = "Conversation ID to learn more about."
  }

  step "pipeline" "get_slack_channel" {
    pipeline = slack.pipeline.get_channel
    args = {
      cred    = param.slack_cred
      channel = param.slack_channel
    }

    # When the requested channel is unavilable, exit the pipeline.
    throw {
      if      = result.errors[0].error.detail == "channel_not_found"
      message = "The requested channel is not found. Exiting the pipeline."
    }
  }

  output "slack_channel" {
    description = "Channel details."
    value       = step.pipeline.get_slack_channel
  }
}
