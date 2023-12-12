# Delete Mail From Microsoft Office 365

Delete an email from a specified user's mailbox in Microsoft Office 365.

## Credentials

By default, the following environment variables will be used for authentication:

- `TEAMS_ACCESS_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/teams.fpc
```

```hcl
credential "teams" "default" {
  access_token = "<access_token>"
}
```

## Usage

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

Run the pipeline and specify the `user_id` and `message_id` pipeline arguments:

```sh
flowpipe pipeline run delete_mail_from_microsoft_office_365 --arg user_id='<user_id>' --arg message_id='<message_id>'
```
