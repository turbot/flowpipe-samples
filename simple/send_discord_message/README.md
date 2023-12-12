# Send Discord Message

Send a message to a Discord channel.

## Usage

- Set your `DISCORD_TOKEN` environment variable or configure your Slack credentials in `~/.flowpipe/config/discord.fpc`:
  ```hcl
  credential "discord" "default" {
    token = "xoxp-12345-..."
  }
  ```
- Run the pipeline and specify the `channel_id` and `message` args, e.g., `flowpipe pipeline run send_discord_message --arg 'channel_id=my-channel' --arg 'message=Hello world!'`
