# Send Message to User in Microsoft Teams

Send an email message to a user in Microsoft Teams and notify them in the specified channel.

## Getting Started

### Credentials

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

### Usage

Run the pipeline and specify the `team_id`, `channel_id` and `message` pipeline arguments:

```sh
flowpipe pipeline run send_message_to_user_in_microsoft_teams --arg to_email='bar@foo.com' --arg subject='Hello from Flowpipe!' --arg content=Hello --arg channel_id='19:fake@thread.tacv2' --arg team_id=fake-team-id
```
