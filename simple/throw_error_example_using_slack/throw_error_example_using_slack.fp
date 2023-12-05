# // usage: flowpipe pipeline run throw_error_example_using_slack --arg channel="C012ABCDZ"
pipeline "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."

  param "slack_token" {
    type        = string
    default     = var.slack_token
    description = "Authentication token bearing required scopes."
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  step "http" "get_channel" {
    url    = "https://slack.com/api/conversations.info"
    method = "post"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${param.slack_token}"
    }

    request_body = "channel=${param.channel}"

    # When the requested channel is unavilable, exit the pipeline.
    throw {
      if      = result.response_body.error == "channel_not_found"
      message = "The requested channel is not found. Exiting the pipeline."
    }
  }

  output "channel" {
    value       = step.http.get_channel.response_body.channel
    description = "Channel details."
  }
}