# Query and Stop AWS EC2 Instances by Tag

Query a list of running AWS EC2 instances with the tag key-value pair `status: decom` using Steampipe and then stop them.

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
aws_cred = "non_default_cred"
```
