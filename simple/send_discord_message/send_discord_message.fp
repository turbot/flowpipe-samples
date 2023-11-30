pipeline "send_discord_message" {
  title       = "Send Discord Message"
  description = "Send a message to a Discord channel."

  param "discord_token" {
    description = "The Discord bot token."
    type        = string
    default     = var.discord_token
  }

  param "channel_id" {
    description = "The ID of the channel to send the message to."
    type        = string
  }

  param "message" {
    description = "The message to send."
    type        = string
  }

  step "pipeline" "create_message" {
    pipeline = discord.pipeline.create_message
    args = {
      token      = param.discord_token
      channel_id = param.channel_id
      message    = param.message
    }
  }

  output "create_message_check" {
    value = !is_error(step.pipeline.create_message) ? "Message '${param.message}' sent to ${param.channel_id}" : "Error sending message: ${error_message(step.pipeline.create_message)}"
  }
}
