# Notify Slack for New GitHub Releases

Notify a Slack channel when a new GitHub release is published.

## Usage

- Add your Slack API token and channel name to `flowpipe.pvars`
- Start your Flowpipe server
- Get the trigger part of the webhook for the `notify_slack_new_github_release` trigger, e.g., `hook/notify_slack_new_github_release.trigger.http.github_webhook_release_events/5d488ba41b4cd34bb15dde8d2c2082b3e4fa99aa3cfddb33e037c2db4587d707`
- Add your [webhook](https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks) to the GitHub repository:
  - Payload URL: Full webhook URL, e.g., `https://my-domain.ngrok-free.app/api/v0/hook/notify_slack_new_github_release.trigger.http.github_webhook_release_events/5d488ba41b4cd34bb15dde8d2c2082b3e4fa99aa3cfddb33e037c2db4587d707`
  - Content type: `application/json`
  - Secret: Can optionally add a secret
  - Events: `Releases`
  - Active: Checked
- Create a new GitHub release in that repository to test your trigger
