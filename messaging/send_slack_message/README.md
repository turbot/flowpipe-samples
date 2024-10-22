# Send Slack Message

Send a message to a Slack channel.

## Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd messaging/send_slack_message
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `SLACK_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/slack.fpc
```

```hcl
connection "slack" "default" {
  token = "xoxp-12345-..."
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `channel` and `text` pipeline arguments:

```sh
flowpipe pipeline run send_slack_message --arg 'channel=channel-name' --arg 'text=Hello world'
```
