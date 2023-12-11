# Send Slack Message

Send a message to a Slack channel.

## Usage

- Set your `SLACK_TOKEN` environment variable or configure your Slack credentials in `~/.flowpipe/config/slack.fpc`:
  ```hcl
  credential "slack" "default" {
    token = "xoxp-12345-..."
  }
  ```
- Run the pipeline and specify the `channel` and `text` args, e.g., `flowpipe pipeline run send_slack_message --arg 'channel=my-channel' --arg 'text=Hello world!'`
