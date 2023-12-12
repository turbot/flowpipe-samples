# Notify Slack for New GitHub Releases

Notify a Slack channel when a new GitHub release is published.

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
cd software/notify_slack_new_github_release
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

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

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

To get notified in Slack when a new GitHub release is published, run:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a webhook event is received.

## Configuration

To run the pipeline automatically whenever a webhook event is received, you can create a GitHub webhook subscription.

To configure the webhook subscription in GitHub:

1. Get the trigger details:
```sh
flowpipe trigger show http.pagerduty_webhook_incident_events
```
2. Copy the `Url`, e.g., `/hook/github_webhook_release_events.trigger.http.github_webhook_release_events/92ffeda03426754f2c79dfaa`
3. Use a tool like [ngrok](https://ngrok.com/) with a custom domain to expose your localhost server to the internet:
```sh
ngrok http 7103 --domain=yellow-neutral-lab.ngrok-free.app
```
4. Form the full webhook URL with the public endpoint from ngrok and the trigger URL using the format `https://{ngrok_domain}.ngrok-free.app/api/v0/{hook_url}`, e.g., `https://yellow-neutral-lab.ngrok-free.app/api/v0/hook/github_webhook_release_events.trigger.http.github_webhook_release_events/92ffeda03426754f2c79dfaa`


To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
slack_channel = "test-channel"
```
