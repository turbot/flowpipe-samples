pipeline "send_teams_message" {
  title       = "Send Teams Message"
  description = "Send a new chat message in the specified channel."

  tags = {
    recommended = "true"
  }

  param "teams_conn" {
    type        = connection.teams
    description = "Name for Microsoft Teams connections to use. If not provided, the default connection will be used."
    default     = connection.teams.default
  }

  param "teams_team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "teams_channel_id" {
    type        = string
    description = "The channel's unique identifier."
  }

  param "teams_message" {
    type        = string
    description = "The message to send."
  }

  param "teams_message_content_type" {
    type        = string
    description = "The type of the content. Possible values are text and html."
    optional    = true
    default     = "text"
  }

  step "pipeline" "send_teams_message" {
    pipeline = teams.pipeline.send_channel_message
    args = {
      conn                 = param.teams_conn
      team_id              = param.teams_team_id
      channel_id           = param.teams_channel_id
      message              = param.teams_message
      message_content_type = param.teams_message_content_type
    }
  }

  output "message" {
    value       = step.pipeline.send_teams_message.output.message
    description = "Channel message details."
  }
}
