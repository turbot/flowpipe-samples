pipeline "throw_error_example_using_slack" {
  title       = "Throw Error Example Using Slack"
  description = "Throw an error if the requested Slack channel is unavailable."

  param "cred" {
    type        = string
    description = "Authentication token bearing required scopes."
    default     = "default"
  }

  param "channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to. Must be an encoded ID."
  }

  step "http" "get_channel" {
    method = "post"
    url    = "https://slack.com/api/conversations.info"

    request_headers = {
      Content-Type  = "application/x-www-form-urlencoded"
      Authorization = "Bearer ${credential.slack[param.cred].token}"
    }

    request_body = "channel=${param.channel}"

    # When the requested channel is unavilable, exit the pipeline.
    throw {
      if      = result.response_body.ok == false
      message = result.response_body.error == "channel_not_found" ? "The requested channel is not found. Exiting the pipeline." : result.response_body.error
    }
  }

  output "channel" {
    value       = step.http.get_channel.response_body.channel
    description = "Channel details."
  }
}
