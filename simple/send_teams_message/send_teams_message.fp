pipeline "send_teams_message" {
  title       = "Send Teams Message"
  description = "Send a new chat message in the specified channel."

  param "team_cred" {
    type        = string
    description = "Name for Microsoft Teams credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "channel_id" {
    type        = string
    description = "The channel's unique identifier."
  }

  param "message" {
    type        = string
    description = "The message to send."
  }

  param "message_content_type" {
    type        = string
    description = "The type of the content. Possible values are text and html."
    optional    = true
    default     = "text"
  }

  step "pipeline" "send_teams_message" {
    pipeline = teams.pipeline.send_channel_message
    args = {
      cred                 = param.team_cred
      team_id              = param.team_id
      channel_id           = param.channel_id
      message              = param.message
      message_content_type = param.message_content_type
    }
  }

  output "message" {
    value       = step.pipeline.send_teams_message.output.message
    description = "Channel message details."
  }
}
