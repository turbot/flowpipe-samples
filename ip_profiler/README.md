# IP Profiler

Get valuable information about IP addresses by bringing data together from AbuseIPDB, ReallyFreeGeoIP, and VirusTotal.

## Credentials

By default, the following environment variables will be used for authentication:

- `ABUSEIPDB_API_KEY`
- `VTCLI_APIKEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/abuseipdb.fpc
```

```hcl
credential "abuseipdb" "default" {
  api_key = "hJ2lFgP7nR9sT4xVhJ2lFgP7nR9sT4xV8aZ0bC3qW6mO1eK5dH7jI9lM3nA2oZ8vB0xK4yV1cX6eA9ds"
}
```

```sh
vi ~/.flowpipe/config/virustotal.fpc
```

```hcl
credential "virustotal" "default" {
  api_key = "AG.U7..."
}
```

No credentials are required for ReallyFreeGeoIP.

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the `channel` and `text` pipeline arguments:

```sh
flowpipe pipeline run ip_profiler --arg 'ip_addresses=["99.84.45.75", "76.76.21.21"]'
```
