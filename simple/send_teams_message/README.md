# Send Teams Message

Send a new chat message in the specified channel.

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

Run the pipeline and specify the `team_id`, `channel_id` and `message` pipeline arguments:

```sh
flowpipe pipeline run send_teams_message --arg team_id=fake-team-id --arg channel_id='19:fake@thread.tacv2' --arg message="Hello from Flowpipe!"
```
