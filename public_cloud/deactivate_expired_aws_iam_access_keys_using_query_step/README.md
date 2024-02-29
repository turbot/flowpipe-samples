# Deactivate expired AWS IAM access keys Using Query Step

Deactivates expired AWS IAM access keys and notifies via Email.

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
cd public_cloud/deactivate_expired_aws_iam_access_keys_using_query_step
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

You need to create `integration` and `notifier` resources in configuration files:

```sh
vi ~/.flowpipe/config/email.fpc
```

```hcl
integration "email" "gmail" {
  smtp_host     = "smtp.gmail.com"
  smtp_tls      = "on"
  smtp_port     = 465
  smtps_port    = 587
  smtp_username = "<Email Username>"
  smtp_password = "<Email APP Password>"
  from          = "<Email Username>"
}

notifier "email_notifier" {
  notify {
    integration = integration.email.gmail
    to          = ["test@gmail.com"]
    subject     = "Deactivated expired AWS IAM Keys"
  }
}
```

## Usage

Run the pipeline:

```sh
flowpipe pipeline run deactivate_expired_aws_iam_access_keys_using_query_step
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
