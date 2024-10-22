# Deactivate Expired AWS IAM Keys

Deactivates expired AWS IAM access keys and notifies via Slack channel.

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
cd public_cloud/deactivate_expired_aws_iam_access_keys
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`
- `SLACK_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi conn.fpc
```

```hcl
connection "aws" "aws_profile" {
  profile = "my-profile"
}

connection "aws" "aws_access_key_pair" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
}

connection "aws" "aws_session_token" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
  session_token = "AQoDX..."
}

connection "slack" "default" {
  token = "xoxp-12345-..."
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `slack_channel` pipeline arguments:

```sh
flowpipe pipeline run deactivate_expired_aws_iam_access_keys --arg slack_channel=my_notification_channel
```

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Optional
# aws_conn   = "non_default_conn"
# slack_conn = "non_default_conn"
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
