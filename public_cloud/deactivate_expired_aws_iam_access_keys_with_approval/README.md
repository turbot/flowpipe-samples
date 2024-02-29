# Deactivate Expired AWS IAM Keys with Approval

Find expired AWS IAM access keys and ask for approval to deactivate or just send a notification.

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
cd public_cloud/deactivate_expired_aws_iam_access_keys_with_approval
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

It is recommended to create a `credential_import` resource:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential_import "steampipe" {
  source      = "~/.steampipe/config/*.spc"
  connections = ["*"]
}
```

For more information on importing credentials, please see [Credential Import](https://flowpipe.io/docs/reference/config-files/credential-import).

## Configuration

Create a `notifier` resource, which will be used to route inputs and other messages.

For instance:

```sh
vi ~/.flowpipe/config/integrations.fpc
```

```hcl
integration "email" "my_email" {
  from          = "user@company.com"
  to            = ["user@company.com"]
  smtp_tls      = "required"
  smtps_port    = 587
  smtp_host     = "smtp.gmail.com"
  smtp_username = "cody@turbot.com"
  smtp_password = env("FLOWPIPE_EMAIL_APP_PW")
}

notifier "my_email" {
  notify {
    integration = integration.email.email_app
  }
}
```

For more examples of integrations and notifiers, please see:
- [Integrations](https://flowpipe.io/docs/reference/config-files/integration)
- [Notifiers](https://flowpipe.io/docs/reference/config-files/notifier)

Then set the variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Optional
#database = "postgres://steampipe@localhost:9193/steampipe"
notifier = "my_email"
```

## Usage

You run the pipeline directly:

```sh
flowpipe pipeline run deactivate_expired_aws_iam_access_keys_with_approval --host local
```

Or run it with the Flowpipe server:

```sh
flowpipe server
```
