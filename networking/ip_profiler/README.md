# IP Profiler

Get valuable information about IP addresses by bringing data together from AbuseIPDB, ReallyFreeGeoIP, and VirusTotal.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd networking/ip_profiler
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `ABUSEIPDB_API_KEY`
- `VTCLI_APIKEY`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/connections.fpc
```

```hcl
connection "abuseipdb" "default" {
  api_key = "hJ2lFgP7nR9sT4xVhJ2lFgP7nR9sT4xV8aZ0bC3qW6mO1eK5dH7jI9lM3nA2oZ8vB0xK4yV1cX6eA9ds"
}

connection "virustotal" "default" {
  api_key = "AG.U7..."
}
```

No connections are required for ReallyFreeGeoIP.

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `ip_addresses` pipeline argument:

```sh
flowpipe pipeline run ip_profiler --arg 'ip_addresses=["99.84.45.75", "76.76.21.21"]'
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [Samples Mod](https://github.com/turbot/flowpipe-samples/labels/help%20wanted)
