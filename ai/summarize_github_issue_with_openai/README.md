# Summarize GitHub Issue with OpenAI

Summarize a GitHub issue with OpenAI and send the results to a Slack channel.

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
cd ai/summarize_github_issue_with_openai
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`
- `OPENAI_API_KEY`
- `SLACK_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/connections.fpc
```

```hcl
connection "github" "default" {
  token = "ghpat-..."
}

connection "openai" "default" {
  api_key = "sk-jwgthNa..."
}

connection "slack" "default" {
  token = "xoxp-12345-..."
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `github_repository_owner`, `github_repository_name`, `github_issue_number`, `openai_system_content`, `openai_max_tokens`, `openai_temperature`,`openai_model`, and `slack_channel` pipeline arguments:

```sh
flowpipe pipeline run summarize_github_issue_with_openai --arg 'github_repository_owner=turbot' --arg 'github_repository_name=flowpipe' --arg 'github_issue_number=478' --arg 'openai_system_content=Hi I am a dev' --arg openai_max_tokens=300 --arg 'openai_temperature=1' --arg 'slack_channel=my-channel' --arg 'openai_model=gpt-3.5-turbo'
```
