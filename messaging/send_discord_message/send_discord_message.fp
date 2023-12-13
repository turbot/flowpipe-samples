pipeline "send_discord_message" {
  title       = "Send Discord Message"
  description = "Send a message to a Discord channel."

  param "discord_cred" {
    type        = string
    description = "Name for Discord credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "discord_channel_id" {
    description = "The ID of the channel to send the message to."
    type        = string
  }

  param "discord_message" {
    description = "The message to send."
    type        = string
  }

  step "pipeline" "create_message" {
    pipeline = discord.pipeline.create_message
    args = {
      cred       = param.discord_cred
      channel_id = param.discord_channel_id
      message    = param.discord_message
    }
  }

  output "create_message_check" {
    value = !is_error(step.pipeline.create_message) ? "Message '${param.message}' sent to ${param.channel_id}" : "Error sending message: ${error_message(step.pipeline.create_message)}"
  }
}
