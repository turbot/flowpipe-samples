trigger "schedule" "send_slack_message_using_cron" {
  description = "Send a message to a Slack channel every minute using cron."
  schedule    = "* * * * *"
  pipeline    = pipeline.send_slack_message_using_cron
}

pipeline "send_slack_message_using_cron" {
  title       = "Send Slack Message Using Cron"
  description = "Send a message to a Slack channel every minute using cron."

  tags = {
    type = "featured"
  }

  param "slack_cred" {
    type        = string
    description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
    default     = var.slack_cred
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
    default     = var.slack_channel
  }

  param "slack_text" {
    type        = string
    description = "The formatted text to describe the content of the message."
    default     = var.slack_text
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      cred    = param.slack_cred
      channel = param.slack_channel
      text    = param.slack_text
    }
  }
}
