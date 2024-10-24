# AWS S3 Bucket Versioning Enforcement

Watches for S3 buckets without versioning enabled and notifies through email asking for approval to enable versioning or delete the bucket.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/aws_s3_bucket_versioning_enforcement
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

It is recommended to create a `connection_import` resource to import your AWS connections:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
connection_import "aws" {
  source      = "~/.steampipe/config/aws.spc"
  connections = ["*"]
}
```

For more information on importing connections, please see [Connection Import](https://flowpipe.io/docs/reference/config-files/connection-import).

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
  smtp_host     = "smtp.mydomain.com"
  smtp_username = "my_user@mydomain.com"
  smtp_password = env("FLOWPIPE_EMAIL_APP_PW")
}

notifier "my_email" {
  notify {
    integration = integration.email.my_email
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
# AWS Region
aws_region = "us-east-1"

# Set the AWS connections profile to use
# aws_conn = "default"

# Steampipe database connection string
# Defaults to local Steampipe database
# You can also set a search path as part of this connection string
# database = "postgresql://steampipe@localhost:9193/steampipe?options=-c%20search_path%3Dput,search,path,here"

# Set the notifier to use for inputs and messages
# Defaults to the "default" notifier
notifier = "my_email"

# Set the schedule for the mod to run
# schedule = "daily"

```

## Usage

Start the Steampipe service:

```sh
steampipe service start
```

**Note**: Please remember to set `search_path` or `search_path_prefix` in your [Steampipe workspace options](https://steampipe.io/docs/reference/config-files/workspace) to ensure the right connections are queried.

Run the mod with the Flowpipe server:

```sh
flowpipe server --verbose
```
