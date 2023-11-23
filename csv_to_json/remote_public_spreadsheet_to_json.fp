pipeline "remote_public_spreadsheet_to_json" {
  title       = "Remote Google Spreadsheet CSV To JSON"
  description = "Read CSV data from a remote Google spreadsheet and convert the contents to JSON."

  param "spreadsheet_id" {
    type        = string
    description = "The ID of the Google Sheet."
  }

  # Using a remote CSV file without authentication
  step "http" "remote_public_spreadsheet_to_json" {
    url = "https://docs.google.com/spreadsheets/d/${param.spreadsheet_id}/export?format=csv"
  }

  output "remote_public_spreadsheet_to_json" {
    value = jsonencode(csvdecode(step.http.remote_public_spreadsheet_to_json.response_body))
  }
}
