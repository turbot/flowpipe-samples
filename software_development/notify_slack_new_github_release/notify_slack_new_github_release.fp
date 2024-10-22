trigger "http" "github_webhook_release_events" {
  title       = "GitHub Webhook Release Events"
  description = "Webhook for GitHub release events."

  pipeline = pipeline.router_pipeline
  args = {
    event        = self.request_headers["X-Github-Event"]
    request_body = jsondecode(self.request_body)
  }
}

pipeline "router_pipeline" {
  title       = "Router Pipeline"
  description = "Read the release event and send a Slack message for new releases."

  param "event" {
    type        = string
    description = "GitHub event."
  }

  param "request_body" {
    type        = any
    description = "GitHub event request body."
  }

  param "conn" {
    type        = connection.slack
    description = "Name of Slack connection to use. If not provided, the default Slack connection will be used."
    default     = connection.slack.default
  }

  param "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
    default     = var.slack_channel
  }

  step "pipeline" "post_message" {
    if = param.event == "release" && param.request_body.action == "published"

    pipeline = slack.pipeline.post_message
    args = {
      conn    = param.conn
      channel = param.slack_channel
      text    = "New release created by ${param.request_body.release.author.login}: ${param.request_body.release.html_url}"
    }
  }

  output "post_message_check" {
    value = !is_error(step.pipeline.post_message) ? "Message sent to ${param.slack_channel}" : "Error sending message: ${error_message(step.pipeline.post_message)}"
  }
}
