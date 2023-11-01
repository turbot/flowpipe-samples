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
    type        = object
    description = "GitHub event request body."
  }

  step "pipeline" "post_message" {
    if = param.event == "release" && param.request_body.action == "published"

    # TODO: Switch once mod install works
    #pipeline = slack_mod.pipeline.post_message
    pipeline = pipeline.slack_post_message
    args = {
      message = "New release created by ${param.request_body.release.author.login}: ${param.request_body.release.html_url}"
    }
  }

  output "message" {
    value = step.pipeline.post_message.output.message
  }
}
