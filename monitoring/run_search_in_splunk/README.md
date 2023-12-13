# Run Search in Splunk

Runs the provided search in Splunk, waits for the search to complete, and returns the results.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd monitoring/run_search_in_splunk
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```
### Credentials

No credentials are required.

## Usage

Run the pipeline to search a query in Splunk

```sh
flowpipe pipeline run run_search_in_splunk --arg 'search_query="search *"' --arg insecure=false
```

### Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
splunk_auth_token = "eyJraWQiOiJzcGx1bmsuc2Vjc..."
splunk_server = "localhost"
```