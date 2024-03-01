# Stop AWS EC2 Instances by input approval

Stop AWS EC2 instance based on the input approval.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads)

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/stop_aws_ec2_instances_by_input_approval
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

Then set the variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Optional
# database = "postgres://steampipe@localhost:9193/steampipe"
notifier = "my_slack"
```

## Usage

Start the Steampipe service:

```sh
steampipe service start
```

**Note**: Please remember to set `search_path` or `search_path_prefix` in your [Steampipe workspace options](https://steampipe.io/docs/reference/config-files/workspace) to ensure the right connections are queried.

Run the mod with the Flowpipe server in one terminal:

```sh
flowpipe server
```

In another terminal, run the mod:

```sh
flowpipe pipeline run stop_aws_ec2_instances_by_input_approval
```
