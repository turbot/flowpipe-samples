mod "run_search_in_splunk" {
  title         = "Run Search in Splunk"
  description   = "Runs the provided search in Splunk, waits for the search to complete, and returns the results."
  documentation = file("./README.md")
  categories    = ["monitoring", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
