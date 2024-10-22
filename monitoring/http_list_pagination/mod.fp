mod "http_list_pagination" {
  title         = "HTTP List Pagination"
  description   = "Paginate the response from HTTP list call."
  documentation = file("./README.md")
  categories    = ["monitoring", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
