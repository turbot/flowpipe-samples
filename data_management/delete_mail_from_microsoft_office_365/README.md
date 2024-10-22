# Delete Mail From Microsoft Office 365

Delete an email from a specified user's mailbox in Microsoft Office 365.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd data_management/delete_mail_from_microsoft_office_365
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

Run the pipeline and specify the `user_id` and `message_id` pipeline arguments:

```sh
flowpipe pipeline run delete_mail_from_microsoft_office_365 --arg user_id='<user_id>' --arg message_id='<message_id>'
```
