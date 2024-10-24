# Send Teams Message

Send a new chat message in the specified channel.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd messaging/send_teams_message
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `TEAMS_ACCESS_TOKEN`

You can also create `connection` resources in configuration files:

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

Run the pipeline and specify the `teams_team_id`, `teams_channel_id` and `teams_message` pipeline arguments:

```sh
flowpipe pipeline run send_teams_message --arg teams_team_id=fake-team-id --arg teams_channel_id='19:fake@thread.tacv2' --arg teams_message="Hello from Flowpipe"
```
