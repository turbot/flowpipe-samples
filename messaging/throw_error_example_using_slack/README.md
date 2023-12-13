# Throw Error Example Using Slack

Throw an error if the requested Slack channel is unavailable.

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
cd messaging/throw_error_example_using_slack
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `SLACK_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/slack.fpc
```

```hcl
credential "slack" "default" {
  token = "xoxp-12345-..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `channel` pipeline arguments:

```sh
flowpipe pipeline run throw_error_example_using_slack --arg channel=C01AABBCCDD
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
