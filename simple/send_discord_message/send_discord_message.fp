pipeline "send_discord_message" {
  title       = "Send Discord Message"
  description = "Send a message to a Discord channel"

  param "discord_token" {
    description = "The Discord BOT token to use"
    type        = string
    default     = var.discord_token
  }

  param "discord_channel_id" {
    description = "The ID of the channel to send the message to"
    type        = number
  }

  param "discord_message" {
    description = "The message to send."
    type        = string
  }

  step "pipeline" "create_message" {
    pipeline = discord.pipeline.create_message
    args = {
      token      = param.discord_token
      channel_id = param.discord_channel_id
      message    = param.discord_message
    }
  }

  output "create_message_check" {
    value = !is_error(step.pipeline.create_message) ? "Message '${param.discord_message}' sent to ${param.discord_channel_id}" : "Error sending message: ${error_message(step.pipeline.create_message)}"
  }
}