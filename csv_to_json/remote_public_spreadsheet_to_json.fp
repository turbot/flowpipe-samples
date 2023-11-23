pipeline "remote_public_spreadsheet_to_json" {
  title       = "Remote Google Spreadsheet CSV To JSON"
  description = "Read CSV data from a remote Google spreadsheet and convert the contents to JSON."

  param "spreadsheet_id" {
    type        = string
    description = "The ID of the Google Sheet."
    default     = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
  }

  # Using a remote CSV file without authentication
  # Default example: https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/
  step "http" "remote_public_spreadsheet_to_json" {
    # url = "https://docs.google.com/spreadsheets/d/${param.spreadsheet_id}/export?format=csv"
    url = "https://github.com/datablist/sample-csv-files/raw/main/files/customers/customers-10000.csv"
  }

  output "remote_public_spreadsheet_to_json" {
    value = jsonencode(csvdecode(step.http.remote_public_spreadsheet_to_json.response_body))
  }
}
