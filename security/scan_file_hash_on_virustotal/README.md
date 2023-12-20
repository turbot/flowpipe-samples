# Scan File Hash on VirusTotal

Scan a file hash and get a full VirusTotal report for it.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd security/scan_file_hash_on_virustotal
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Credentials

By default, the following environment variables will be used for authentication:

- `VTCLI_APIKEY`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "virustotal" "my_virustotal" {
  api_key = "AG.U7..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to scan a file hash and get a full VirusTotal report for it:

```sh
flowpipe pipeline run scan_file_hash_on_virustotal --arg file_hash=064a092ae11000000000000000000000000000

```

### Configuration

No additional configuration is required.
