trigger "schedule" "send_slack_message_using_cron" {
  title       = "Send Slack Message Using Cron"
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

  param "slack_conn" {
    type        = connection.slack
    description = "Name for Slack connections to use. If not provided, the default connection will be used."
    default     = var.slack_conn
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
    default     = var.channel
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
    default     = var.text
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      conn    = param.slack_conn
      channel = param.channel
      text    = param.text
    }
  }
}
