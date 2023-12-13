# AWS IAM User Group Membership

Check for AWS IAM users with multiple group membership and automate GitHub issue management at 9 AM UTC on weekdays.

If run with `flowpipe server`, this mod will create/update/close GitHub issues every weekday at 9 AM UTC.

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
cd public_cloud/aws_iam_user_group_membership
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`
- `GITHUB_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "aws" "aws_profile" {
  profile = "my-profile"
}

credential "aws" "aws_access_key_pair" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
}

credential "aws" "aws_session_token" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
  session_token = "AQoDX..."
}

credential "github" "default" {
  token = "ghp_..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to check IAM user group membership and manage corresponding GitHub issues immediately:

```sh
flowpipe pipeline run aws_iam_user_group_membership --arg github_repository_owner=my_gh_org --arg github_repository_name=my_gh_repo
```

To perform the IAM user group membership check at the scheduled time, start the Flowpipe server:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically at the scheduled time.

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Optional
# github_cred = "non_default_cred"
# aws_cred    = "non_default_cred"
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Flowpipe Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
