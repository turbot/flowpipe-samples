# Send Slack Message

Send a message to a Slack channel.

## Credentials

By default, the following environment variables will be used for authentication:

- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/slack.fpc
```

```hcl
credential "slack" "default" {
  token = "xoxp-12345-..."
}
```

## Usage

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

Run the pipeline and specify the `channel` and `text` pipeline arguments:

```sh
flowpipe pipeline run send_slack_message --arg 'channel=my-channel' --arg 'text=Hello world!'
```
