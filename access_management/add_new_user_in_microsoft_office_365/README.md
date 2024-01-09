# Add New User in Microsoft Office 365

Add a new user in Microsoft Office 365.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd access_management/add_new_user_in_microsoft_office_365
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`
- `TEAMS_ACCESS_TOKEN`

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
vi ~/.flowpipe/config/teams.fpc
```

```hcl
credential "teams" "default" {
  access_token = "<access_token>"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `teams_display_name`, `teams_account_enabled`, `teams_mail_nickname`, `teams_user_principal_name`, `teams_password`, `teams_license_sku_ids`, `jira_project_key`, `teams_team_id` and `teams_message` pipeline arguments:

```sh
flowpipe pipeline run add_new_user_in_microsoft_office_365 \
  --arg teams_display_name='John Doe' \
  --arg teams_account_enabled=true \
  --arg teams_mail_nickname='john.doe' \
  --arg teams_user_principal_name='john.doe@foo.com' \
  --arg teams_password='P@ssw0rd' \
  --arg teams_license_sku_ids='["<license_sku_id>"]' \
  --arg jira_project_key='project-foo' \
  --arg teams_team_id='<team_id>' \
  --arg teams_message='New user created'
```
