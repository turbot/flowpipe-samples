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
    value = file("${param.local_csv_file_path}")
  }

  output "local_csv_file_to_json" {
    value = csvdecode(step.transform.local_csv_file_to_json.value)
  }


}




