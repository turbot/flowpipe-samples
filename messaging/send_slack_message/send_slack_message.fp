pipeline "send_slack_message" {
  title       = "Send Slack Message"
  description = "Send a message to a Slack channel."

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
    description = "Channel, private group, or IM channel to send message to."
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      conn    = param.slack_conn
      channel = param.channel
      text    = param.text
    }
  }

  output "post_message_check" {
    value = !is_error(step.pipeline.post_message) ? "Message '${param.text}' sent to ${param.channel}" : "Error sending message: ${error_message(step.pipeline.post_message)}"
  }
}
