# Deactivate Expired AWS IAM Keys with Approval

Find expired AWS IAM access keys and ask for approval to deactivate or just send a notification.

## Requirements

[Steampipe](https://steampipe.io/downloads) must be installed along with the [AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Installation

Download and install [Flowpipe](https://flowpipe.io/downloads). Or use Brew:

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

It is recommended to create a `credential_import` resource to import your AWS connections:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential_import "aws" {
  source      = "~/.steampipe/config/aws.spc"
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
  smtp_username = "user@company.com"
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

To update your database connection string, search path, or notifier, set the variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Steampipe database connection string
# Defaults to local Steampipe database
# You can also set a search path as part of this connection string
database = "postgresql://steampipe@localhost:9193/steampipe?options=-c%20search_path%3Dput,search,path,here"

# Set the notifier to use for inputs and messages
# Defaults to the "default" notifier
notifier = "my_email"
```

## Usage

Start the Steampipe service:

```sh
steampipe service start
```

Start the Flowpipe server:

```sh
flowpipe server
```
