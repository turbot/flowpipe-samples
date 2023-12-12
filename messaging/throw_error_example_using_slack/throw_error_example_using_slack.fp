pipeline "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."

  param "channel" {
    type        = string
    description = "Conversation ID to learn more about."
  }

  step "pipeline" "get_channel" {
    pipeline = slack.pipeline.get_channel
    args = {
      channel = param.channel
    }

    # When the requested channel is unavilable, exit the pipeline.
    throw {
      if      = result.errors[0].error.detail == "channel_not_found"
      message = "The requested channel is not found. Exiting the pipeline."
    }
  }

  output "channel" {
    description = "Channel details."
    value       = step.pipeline.get_channel
  }
}
