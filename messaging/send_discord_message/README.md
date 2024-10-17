# Send Discord Message

Send a message to a Discord channel.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd messaging/send_discord_message
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `DISCORD_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/discord.fpc
```

```hcl
connection "discord" "default" {
  token = "xoxp-12345-..."
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `discord_channel_id` and `discord_message` pipeline arguments:

```sh
flowpipe pipeline run send_discord_message --arg 'discord_channel_id=1162602104318332928' --arg 'discord_message=Hello world'
```
