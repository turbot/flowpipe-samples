pipeline "local_csv_file_to_json" {
  title       = "Local CSV File To JSON"
  description = "Read a CSV file and convert the contents to JSON."

  param "local_csv_file_path" {
    type        = string
    description = "The path to the CSV file."
    default     = "./users.csv"
  }

  # Using a local file
  step "transform" "local_csv_file_to_json" {
    value = jsonencode(csvdecode(file("${param.local_csv_file_path}")))
  }

  output "csv_contents" {
    value = file("${param.local_csv_file_path}")
  }

  output "csvdecoded" {
    value = csvdecode(file("${param.local_csv_file_path}"))
  }

  output "csv2json" {
    value = step.transform.local_csv_file_to_json.value
  }

}
