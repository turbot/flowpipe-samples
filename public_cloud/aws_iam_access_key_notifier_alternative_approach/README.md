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

For the e-mail notification, you need to set the SMTP credentials and recipient email address at the `flowpipe.fpvars` file as shown below.

```hcl
email_from    = "sender-email@my-server.com"
email_to      = ["recipient-one@my-server.com", "recipient-two@my-server.com"]

smtp_username = "my-smtp-username"
smtp_password = "my-smtp-password"
smtp_host     = "smtp.mydomain.com"
smtp_port     = 587
```

## Usage

To get notified in Slack when a new IAM access key is created, run:

```sh
steampipe service start
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically whenever a query trigger state is received.
