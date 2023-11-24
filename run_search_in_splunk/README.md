# Run Search in Splunk

Runs the provided search in Splunk, waits for the search to complete, and returns the results.

## Usage

- Add your Splunk Auth Token and Splunk Server to `flowpipe.pvars`
- Run the pipeline and specify `search_query`, e.g., `flowpipe pipeline run run_search_in_splunk --arg 'search_query="search *"'`
