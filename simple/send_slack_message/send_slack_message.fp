pipeline "send_slack_message" {
  title       = "Send Slack Message"
  description = "Send a message to a Slack channel."

  param "slack_token" {
    type        = string
    description = "Authentication token bearing required scopes."
    default     = var.slack_token
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
  }

  param "message" {
    type        = string
    description = "Message to be sent."
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      token   = param.slack_token
      channel = param.channel
      message = param.message
    }
  }

  output "post_message_check" {
    value = !is_error(step.pipeline.post_message) ? "Message '${param.message}' sent to ${param.channel}" : "Error sending message: ${error_message(step.pipeline.post_message)}"
  }
}
