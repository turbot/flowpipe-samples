# Send Discord Message

Send a message to a Discord channel.

## Usage

- Add your Discord API bot token to `flowpipe.pvars`
- Run the pipeline and specify the `channel_id` and `message` args, e.g., `flowpipe pipeline run send_discord_message --arg 'channel_id=1234567890' --arg 'message=Hello world!'
