# Send Teams Message

Send a new chat message in the specified channel.

## Usage

- Add your Teams Access token and ID to `flowpipe.pvars`
- Run the pipeline and specify the `channel_id` and `message` args, e.g., `flowpipe pipeline run send_teams_message --arg 'channel_id=944a8e14-7a6f-48c6-8805-6e93612f' --arg 'message=Hello world!'
