pipeline "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."

  tags = {
    recommended = "true"
  }

  param "slack_conn" {
    type        = connection.slack
    description = "Name for Slack connections to use. If not provided, the default connection will be used."
    default     = connection.slack.default
  }

  param "channel" {
    type        = string
    description = "The requested Slack channel ID."
  }

  step "pipeline" "get_channel" {
    pipeline = slack.pipeline.get_channel
    args = {
      conn    = param.slack_conn
      channel = param.channel
    }

    # When the requested channel is unavailable, exit the pipeline.
    throw {
      if      = try(result.errors[0].error.detail, "test") == "channel_not_found"
      message = "The requested channel is not found. Exiting the pipeline."
    }
  }

  output "channel" {
    description = "Channel details."
    value       = step.pipeline.get_channel
  }
}
