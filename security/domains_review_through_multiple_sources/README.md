# Analyze Domains Through Multiple Sources

Investigate suspicious domains and identify false positives by leveraging threat intelligence tools, including URLhaus, VirusTotal, and URLScan, to gather more context and respond faster.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd security/domains_review_through_multiple_sources
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Credentials

By default, the following environment variables will be used for authentication:

- `VTCLI_APIKEY`
- `URLSCAN_API_KEY`
- `IP2LOCATIONIO_API_KEY`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "virustotal" "my_virustotal" {
  api_key = "AG.U7..."
}
```

```hcl
credential "urlscan" "my_urlscan" {
  api_key = "AKIA...2"
}
```

```hcl
credential "ip2locationio" "my_ip2locationio" {
  token = "00B630jSCGU4jV4o5Yh4KQMAdqizwE2OgVcS7N9UHb"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to analyze domains through multiple sources:

```sh
flowpipe pipeline run domains_review_through_multiple_sources --arg 'domain=example.com'
```

### Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
apivoid_api_key="Your_APIVoid_API_Key"
```