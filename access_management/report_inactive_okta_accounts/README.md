# Report Inactive Okta Accounts

Routinely scan Okta environments for potential inactive accounts and deactivate accounts within the case if necessary.

If run with `flowpipe server`, this mod will run the scan every day at 9 AM UTC.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd access_management/report_inactive_okta_accounts
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`
- `OKTA_TOKEN`
- `OKTA_ORGURL`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
credential "jira" "default" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

```sh
vi ~/.flowpipe/config/okta.fpc
```

```hcl
credential "okta" "default" {
  domain    = "https://test.okta.com"
  api_token = "00B63........"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to run the scan immediately:

```sh
flowpipe pipeline run report_inactive_okta_accounts --arg project_key=project-foo --arg issue_type=Task --arg inactive_hours=48
```

To run the scan at the scheduled time, start the Flowpipe server:

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
inactive_hours = "48"
issue_type     = "Task"
project_key    = "project-foo"


# Optional
# jira_cred = "non_default_cred"
# okta_cred = "non_default_cred"
```
