# Send Slack Message

Send a message to a Slack channel.

## Usage

- Add your Slack API token to `flowpipe.pvars`
- Run the pipeline and specify the `channel` and `message` args, e.g., `flowpipe pipeline run send_slack_message --arg 'channel=my-channel' --arg 'message=Hello world!'
