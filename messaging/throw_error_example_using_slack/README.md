# Throw Error Example Using Slack

Throw an error if the requested Slack channel is unavailable.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd messaging/throw_error_example_using_slack
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

Run the pipeline and specify the `channel` pipeline arguments:

```sh
flowpipe pipeline run throw_error_example_using_slack --arg 'channel=channel-name'
```
