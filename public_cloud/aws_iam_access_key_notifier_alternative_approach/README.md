# AWS IAM Access Key Notifier

Watches for IAM access keys creations, changes and deletions and notifies through email.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/aws_iam_access_key_notifier
```

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
# Optional
# database = "postgres://steampipe@localhost:9193/steampipe"
# schedule = "daily"
notifier = "my_email"
```

## Usage

Start the Steampipe service:

```sh
steampipe service start
```

**Note**: Please remember to set `search_path` or `search_path_prefix` in your [Steampipe workspace options](https://steampipe.io/docs/reference/config-files/workspace) to ensure the right connections are queried.

Run the mod with the Flowpipe server:

```sh
flowpipe server
```