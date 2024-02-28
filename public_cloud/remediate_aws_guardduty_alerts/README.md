# Remediate AWS Guard Duty Alerts

Automate AWS SNS notifications from Guard Duty Findings triggering Jira issue creation, execute actions in AWS for identified issues, and update issue state to "done" upon resolution.AWS GuardDuty alerts based on different event types triggered.

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
cd public_cloud/remediate_aws_guardduty_alerts
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`
- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
credential "jira" "default" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3..."
  username    = "abc@email.com"
}
```

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential "aws" "default" {
  profile = "my-profile"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

To get AWS Guard Duty alerts and remediate them, run:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a webhook event is received.

## Configuration

To run the pipeline automatically whenever a webhook event is received, you can create a AWS GuardDuty Findings webhook subscription.

To configure the webhook subscription in AWS:

1. Get the trigger details:
  ```sh
  flowpipe trigger show http.pagerduty_webhook_incident_events
  ```
2. Copy the `Url`, e.g., `/hook/remediate_aws_guardduty_alerts.trigger.http.remediate_aws_guardduty_alerts/92ffeda03426754f2c79dfaa`
3. Use a tool like [ngrok](https://ngrok.com/) with a custom domain to expose your localhost server to the internet:
  ```sh
  ngrok http 7103 --domain=yellow-neutral-lab.ngrok-free.app
  ```
4. Form the full webhook URL with the public endpoint from ngrok and the trigger URL using the format `https://{ngrok_domain}.ngrok-free.app/api/v0/{hook_url}`, e.g., `https://yellow-neutral-lab.ngrok-free.app/api/v0/hook/remediate_aws_guardduty_alerts.trigger.http.remediate_aws_guardduty_alerts/92ffeda03426754f2c79dfaa`
5. Create AWS SNS topic and subscribe to the topic with the webhook URL.
6. Create AWS EventBridge rule to trigger the SNS topic on GuardDuty Finding event.

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
jira_project_key="QWR"
issue_type="Bug"

aws_region = "us-east-1"
```
