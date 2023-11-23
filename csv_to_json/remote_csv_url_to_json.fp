pipeline "remote_csv_url_to_json" {
  title       = "Remote CSV URL file To JSON"
  description = "Read CSV data from a remote URL and convert the contents to JSON."

  param "url" {
    type        = string
    description = "The URL which contains the CSV data."
  }

  step "http" "remote_csv_url_to_json" {
    url = param.url
  }

  output "remote_csv_url_to_json" {
    value = jsonencode(csvdecode(step.http.remote_csv_url_to_json.response_body))
  }
}
