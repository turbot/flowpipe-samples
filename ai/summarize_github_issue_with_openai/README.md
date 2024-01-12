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

## Credentials

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`
- `OPENAI_API_KEY`
- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "github" "default" {
  token = "ghpat-..."
}

credential "openai" "default" {
  api_key = "sk-jwgthNa..."
}

credential "slack" "default" {
  token = "xoxp-12345-..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `github_repository_owner`, `github_repository_name`, `github_issue_number`, and `slack_channel` pipeline arguments:

```sh
flowpipe pipeline run summarize_github_issue_with_openai --arg github_repository_owner=turbot --arg github_repository_name=flowpipe --arg github_issue_number=478 --arg slack_channel=my-channel
```
