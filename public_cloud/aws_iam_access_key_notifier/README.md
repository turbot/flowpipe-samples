# AWS IAM Access Key Notifier

Watches for IAM access keys creations, changes and deletions and notifies through email.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads) and Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap/flowpipe
brew tap turbot/tap/steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/aws_iam_access_key_notifier
```

## Credentials

For the AWS, this mod uses the AWS credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

For notification, we recommend using the Flowpipe email notifier. To configure it, open the `~/.flowpipe/config/flowpipe.fpc` file and add the following:

```hcl
integration "email" "email_app" {
  from      = "sender-email@my-server.com"
  to        = ["recipient-one@my-server.com", "recipient-two@my-server.com"]
  subject = "Flowpipe Notification"
  smtp_tls   = "my-smtp-username"
  smtps_port = 587
  smtp_host = "smtp.mydomain.com"
  smtp_username = "my-smtp-username"
  smtp_password = "my-smtp-password"
}

notifier "email" {
  notify {
    integration = integration.email.email_app
  }
}
```

## Usage

To get notified in Slack when a new IAM access key is created, run:

```sh
steampipe service start
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a query trigger state is received.
