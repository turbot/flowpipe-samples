# Run Search in Splunk

Runs the provided search in Splunk, waits for the search to complete, and returns the results.

### Credentials

You can configure the credentials by defining the variable as shown below:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
splunk_auth_token = "eyJraWQiOiJzcGx1bmsuc2Vjc..."
splunk_server = "localhost"
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to search a query in Splunk

```sh
flowpipe pipeline run run_search_in_splunk --arg 'search_query="search *"' --arg insecure=false
```

### Configuration

No additional configuration is required.