// TODO: Remove after mod install works again
pipeline "slack_post_message" {
  title       = "Slack Post Message"
  description = "Post a message to a channel."

  param "token" {
    type        = string
    default     = var.slack_token
    description = "Authentication token bearing required scopes."
  }

  param "message" {
    type        = string
    description = "The formatted text of the message to be published."
  }

  param "channel" {
    type        = string
    default     = var.slack_channel
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  step "http" "post_message" {
    url    = "https://slack.com/api/chat.postMessage"
    method = "post"

    request_headers = {
      Content-Type  = "application/json; charset=utf-8"
      Authorization = "Bearer ${param.token}"
    }

    request_body = jsonencode({
      channel      = param.channel
      text         = param.message
      # TODO: Do we need to specify these?
      #unfurl_links = true
      #unfurl_media = true
      #thread_ts    = true
    })
  }

  output "message" {
    value       = step.http.post_message.response_body
    description = "Message details."
  }
}
