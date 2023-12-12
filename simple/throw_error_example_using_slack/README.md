# Throw Error Example Using Slack

Throw an error if the requested Slack channel is unavailable.

## Getting Started

### Credentials

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

### Usage

Run the pipeline and specify the `channel` pipeline arguments:

```sh
flowpipe pipeline run throw_error_example_using_slack --arg channel=C01AABBCCDD
```
