# Analyze Domains Through Multiple Sources

Investigate suspicious domains and identify false positives by leveraging threat intelligence tools, including URLhaus, VirusTotal, and URLScan, to gather more context and respond faster.

## Getting Started

### Credentials

By default, the following environment variables will be used for authentication:

- `VTCLI_APIKEY`
- `URLSCAN_API_KEY`
- `IP2LOCATION_API_KEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/virustotal.fpc
```

```hcl
credential "virustotal" "my_virustotal" {
  api_key = "AG.U7..."
}
```

```sh
vi ~/.flowpipe/config/urlscan.fpc
```

```hcl
credential "urlscan" "my_urlscan" {
  api_key = "AKIA...2"
}
```

```sh
vi ~/.flowpipe/config/ip2location.fpc
```

```hcl
credential "ip2location" "my_ip2location" {
  token = "00B630jSCGU4jV4o5Yh4KQMAdqizwE2OgVcS7N9UHb"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to analyze domains through multiple sources:

```sh
flowpipe pipeline run domains_review_through_multiple_sources --pipeline-arg 'domain=example.com'
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