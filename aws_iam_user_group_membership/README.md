# AWS IAM User Group Membership

Check for AWS IAM users with multiple group membership and automate GitHub issue management at 9 AM UTC on weekdays.

If run with `flowpipe server`, this mod will create/update/close GitHub issues every weekday at 9 AM UTC.

## Credentials

By default, the following environment variables will be used for authentication:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`
- `GITHUB_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/aws.fpc
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

```sh
vi ~/.flowpipe/config/github.fpc
```

```hcl
credential "github" "default" {
  token = "ghp_..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to check IAM user group membership and manage corresponding GitHub issues immediately:

```sh
flowpipe pipeline run aws_iam_user_group_membership
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
# Required
aws_region                  = "us-east-1"
github_repository_full_name = "turbot/steampipe"

# Optional
# github_cred = "non_default_cred"
# aws_cred    = "non_default_cred"
```
