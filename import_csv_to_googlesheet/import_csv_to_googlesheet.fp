// curl -L "https://opendata.ecdc.europa.eu/covid19/testing/csv/data.csv" -o data.csv

pipeline "import_csv_to_googlesheet" {
  title       = "Import Data from Remote CSV URL in Googlesheet"
  description = "Import data from remote CSV url to new googlesheet."

  param "url" {
    type        = string
    description = "The URL which contains the CSV data."
    default     = "https://data.nasa.gov/resource/nj3a-8wq3.csv"
  }

  param "access_token" {
    description = "The access token used for authentication."
    type        = string
    default     = var.access_token
    # TODO: Add once supported
    # sensitive  = true
  }

  step "http" "remote_csv_url_to_csv" {
    url = param.url
  }

  step "pipeline" "create_spreadsheet" {
    depends_on = [step.http.remote_csv_url_to_csv]
    pipeline   = googleworkspace.pipeline.create_blank_spreadsheet
    args = {
      access_token      = param.access_token
      spreadsheet_title = "spreadsheet_title"
    }
  }


// curl -X POST \
//   -H "Authorization: Bearer ya29.a0AfB_byAjigATBITvH-0hrdFGr7QKwwShfc7DhFbbHZx-a-et7x2i5sah2gi54hp6inCW0D8n7H-CX06xdxIG7pSI9KsEYgTUYc4ZIz5ChoCV9USlPxeCqFW8Zkg3cAVuvi4tgnMfOdaLSsNDsmOEf5iIxQgmz_xMwkjaaCgYKAWESARISFQHGX2MiYVytizNc9_KJUSSQYisqkA0171" \
//   -H "Content-Type: application/json" \
//   --data-binary @/Users/raj/raj-professional-tasks/flowpipes/flowpipe-mod-googleworkspace/test.json \
//   "https://sheets.googleapis.com/v4/spreadsheets/1U8jWIV4t6O_EudFkL9MVyA7kwqsqgCVHcdJxLyN5N4M/values/Sheet1\!A1:append?valueInputOption=RAW"


  output "remote_csv_data" {
    value = csvdecode(step.http.remote_csv_url_to_csv.response_body)
  }

  output "remote_json_data" {
    value = jsonencode(csvdecode(step.http.remote_csv_url_to_csv.response_body))
  }

  output "spreadsheet_id" {
    value = step.pipeline.create_spreadsheet.output.spreadsheet.spreadsheetId
  }
}