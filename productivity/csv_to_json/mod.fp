mod "csv_to_json" {
  title         = "CSV to JSON"
  description   = "Convert the CSV contents to JSON."
  documentation = file("./README.md")
  categories    = ["productivity", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
