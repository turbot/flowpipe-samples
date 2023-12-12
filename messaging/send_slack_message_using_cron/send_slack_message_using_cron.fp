trigger "schedule" "send_slack_message_using_cron" {
  description = "Send a message to a Slack channel every minute using cron."
  schedule    = "* * * * *"
  pipeline    = pipeline.send_slack_message_using_cron
}

pipeline "send_slack_message_using_cron" {
  title       = "Send Slack Message Using Cron"
  description = "Send a message to a Slack channel every minute using cron."

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  param "text" {
    type        = string
    description = "The formatted text to describe the content of the message."
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      channel = param.channel
      text    = param.text
    }
  }
}
