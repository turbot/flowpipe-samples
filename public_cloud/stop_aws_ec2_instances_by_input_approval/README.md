# Stop AWS EC2 Instances by input approval

Stop AWS EC2 instance based on the input approval.

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
cd public_cloud/stop_aws_ec2_instances_by_input_approval
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

You need to update the `integration.fpc` present in the current directory and provide the channel information:

```sh
integration "slack" "slack_app" {
  token = env("SLACK_TOKEN")
}

notifier "slack" {
  notify {
    integration = integration.slack.slack_app
    channel     = "#random"
  }
}
```

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

Run the pipeline:

```sh
flowpipe pipeline run stop_aws_ec2_instances_by_input_approval
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
