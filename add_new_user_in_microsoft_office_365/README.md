# Add New User in Microsoft Office 365

Add a new user in Microsoft Office 365.

## Getting Started

### Credentials

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

### Usage

Run the pipeline and specify the `display_name`, `account_enabled`, `mail_nickname`, `user_principal_name`, `password`, `license_sku_ids`, `jira_project_key`, `team_id` and `message` pipeline arguments:

```sh
flowpipe pipeline run add_new_user_in_microsoft_office_365 --arg display_name='John Doe' --arg account_enabled=true --arg mail_nickname='john.doe' --arg user_principal_name='john.doe@foo.com' --arg password='P@ssw0rd' --arg license_sku_ids='["<license_sku_id>"]' --arg jira_project_key='project-foo' --arg team_id='<team_id>' --arg message='New user created'
```
