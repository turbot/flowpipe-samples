# Deactivate Expired AWS IAM Keys With Approval

Find expired AWS IAM access keys and ask for approval to delete or send a notification.

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

By default, the following environment variables will be used for authentication:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential "aws" "default" {
  profile = "my-profile"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

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
# aws_cred   = "non_default_cred"
# slack_cred = "non_default_cred"
```
