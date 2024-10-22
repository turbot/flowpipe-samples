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

## Connections

By default, the following environment variables will be used for authentication:

- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`
- `TEAMS_ACCESS_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
connection "jira" "default" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

```sh
vi ~/.flowpipe/config/teams.fpc
```

```hcl
connection "teams" "default" {
  access_token = "<access_token>"
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `teams_display_name`, `teams_account_enabled`, `teams_mail_nickname`, `teams_user_principal_name`, `teams_password`, `teams_license_sku_ids`, `jira_project_key`, `teams_team_id` and `teams_message` pipeline arguments:

```sh
flowpipe pipeline run add_new_user_in_microsoft_office_365 \
  --arg 'teams_display_name=Hero me2' \
  --arg 'teams_account_enabled=true' \
  --arg 'teams_mail_nickname=hero.meee' \
  --arg 'teams_user_principal_name=testfp5@turbotad.onmicrosoft.com' \
  --arg 'teams_password=P@ssw0rd' \
  --arg 'teams_license_sku_ids=["6470687e-a428-4b7a-bef2-8a291ad947c9"]' \
  --arg 'jira_project_key=TEST' \
  --arg 'jira_issue_type=Task' \
  --arg 'teams_team_id=f137966a-52be-4c32-a28f-9665634ba181' \
  --arg 'teams_roles=["member"]' \
  --arg 'teams_message_content_type=text' \
  --arg 'teams_message=New user created'
```
