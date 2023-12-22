# Query and Stop AWS EC2 Instance

Query and Stop AWS EC2 Instance based on the tag value.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/query_and_stop_aws_ec2_instance
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
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `aws_region` pipeline arguments:

```sh
flowpipe pipeline run query_and_stop_aws_ec2_instance --arg aws_region=us-east-1
```

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Optional
# aws_cred = "non_default_cred"
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
