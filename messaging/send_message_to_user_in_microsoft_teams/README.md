# Send Message to User in Microsoft Teams

Send an email message to a user in Microsoft Teams and notify them in the specified channel.

## Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd messaging/send_message_to_user_in_microsoft_teams
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

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

Run the pipeline and specify the `team_id`, `channel_id` and `message` pipeline arguments:

```sh
flowpipe pipeline run send_message_to_user_in_microsoft_teams --arg to_email='bar@foo.com' --arg subject='Hello from Flowpipe!' --arg content=Hello --arg channel_id='19:fake@thread.tacv2' --arg team_id=fake-team-id
```
