# Add S3 Bucket Cost Center Tags

Find S3 buckets without the `cost_center` tag and add a new tag with a user selected value.

## Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Getting Started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads) and Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew install turbot/tap/flowpipe
brew install turbot/tap/steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Steampipe will automatically use your default AWS credentials. Optionally, you can [setup multiple accounts](https://hub.steampipe.io/plugins/turbot/aws#multi-account-connections) or [customize AWS credentials](https://hub.steampipe.io/plugins/turbot/aws#configuring-aws-credentials).

Create a `credential_import` resource to import your Steampipe AWS connections:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential_import "aws" {
  source      = "~/.steampipe/config/aws.spc"
  connections = ["*"]
}
```

For more information on importing credentials, please see [Credential Import](https://flowpipe.io/docs/reference/config-files/credential_import).

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/add_s3_bucket_cost_center_tags
```

### Usage

Start the Steampipe service:

```sh
steampipe service start
```

Start the Flowpipe server:

```sh
flowpipe server
```

### Notifiers

By default, all messages will be sent to the terminal. You can setup an [integration](https://flowpipe.io/docs/reference/config-files/integration) and a [notifier](https://flowpipe.io/docs/reference/config-files/notifier) to send the notification through email, Slack, or any other supported integration.

To send messages through email instead:

```sh
vi ~/.flowpipe/config/integrations.fpc
```

```hcl
integration "email" "default" {
  smtp_tls      = "required"
  smtps_port    = 587
  smtp_host     = "smtp.gmail.com"
  smtp_username = "dwight@dmi.com"
  smtp_password = env("MY_EMAIL_PASSWORD")
  from          = "dwight@dmi.com"
}

notifier "my_email" {
  notify {
    integration = integration.email.default
    to          = ["security@dmi.com"]
  }
}
```

Then set the `notifier` variable:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Set the notifier to use for inputs and messages
# Defaults to the "default" notifier
notifier = "my_email"
```
