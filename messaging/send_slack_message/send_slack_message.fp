pipeline "send_slack_message" {
  title       = "Send Slack Message"
  description = "Send a message to a Slack channel."

  tags = {
    type = "featured"
  }

  param "slack_cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = "default"
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
      cred    = param.slack_cred
      channel = param.channel
      text    = param.text
    }
  }

  output "post_message_check" {
    value = !is_error(step.pipeline.post_message) ? "Message '${param.text}' sent to ${param.channel}" : "Error sending message: ${error_message(step.pipeline.post_message)}"
  }
}
