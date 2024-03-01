# Notify Slack or Email for New IAM Access Key Create

Notify a slack channel or email when a new IAM access key is created.

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
cd software_development/notify_slack_iam_access_key_create
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

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Configuration

Create a `notifier` resource, which will be used to route inputs and other messages.

For instance:

```sh
vi ~/.flowpipe/config/integrations.fpc
```

```hcl
integration "slack" "slack_app" {
  token = env("SLACK_TOKEN")
}
notifier "my_slack" {
  notify {
    integration = integration.slack.slack_app
    channel     = "#random"
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
notifier = "my_slack"
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