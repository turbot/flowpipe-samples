# Flowpipe Samples

A collection of Flowpipe mods that can be used with [Flowpipe](https://flowpipe.io).

## Documentation

- **[Mods →](https://hub.flowpipe.io/?type=sample#search)**

## Getting Started

### Requirements

Each mod has its own requirements, please see the mod's README.md for any requirements, like running the Docker daemon.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd flowpipe-samples
```

### Usage

Navigate to a mod:

```sh
cd monitoring/http_list_pagination
```

Install mod dependencies:

```sh
flowpipe mod install
```

Run a pipeline:

```sh
flowpipe pipeline run http_list_pagination
```

Some mods require [credentials](https://flowpipe.io/docs/run/credentials) and [variables](https://flowpipe.io/docs/build/mod-variables), please see each mod's README.md for specific instructions.

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Flowpipe Samples](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
