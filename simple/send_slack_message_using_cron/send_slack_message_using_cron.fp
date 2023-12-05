trigger "schedule" "send_slack_message_using_cron" {
  description = "Send a message to a Slack channel every minute using cron."
  schedule    = "* * * * *"
  pipeline    = pipeline.send_slack_message_using_cron
}

pipeline "send_slack_message_using_cron" {
  title       = "Send Slack Message Using Cron"
  description = "Send a message to a Slack channel every minute using cron."

  param "slack_token" {
    type        = string
    description = "Authentication token bearing required scopes."
    default     = var.slack_token
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
    default     = var.slack_channel
  }

  param "message" {
    type        = string
    description = "Message to be sent."
    default     = var.message
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      token   = param.slack_token
      channel = param.slack_channel
      message = param.message
    }
  }
}
