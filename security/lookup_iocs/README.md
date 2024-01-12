# Analyze Lookup IOCs in Different Tools

Looks up submitted IOCs (Indicators of Compromise) in different applications and services, including AbuseIPDB, Hunter.io, VirusTotal, etc., and then returns selected results.

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
cd security/lookup_iocs
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Credentials

By default, the following environment variables will be used for authentication:

- `ABUSEIPDB_API_KEY`
- `VTCLI_APIKEY`
- `URLSCAN_API_KEY`
- `IP2LOCATIONIO_API_KEY`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "abuseipdb" "abuseipdb_api_key" {
  api_key = "bfc6f1c42dsfsdfdxxxx26977977b2xxxsfsdda98f313c3d389126de0d"
}
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

Run the pipeline to lookup IOCs in different tools

```sh
flowpipe pipeline run lookup_iocs --arg 'iocs=[{"id" : "1","type" : "ip","value" : "192.168.1.10"},{"id" : "2","type" : "domain","value" : "malicious-domain.com"}]'`
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
hunter_api_key="Your_Hunter_API_Key"
kickbox_api_key="Your_Kickbox_API_Key"
hybrid_analysis_api_key="Your_Hybrid_Analysis_API_Key"
```