pipeline "local_csv_file_to_json" {
  title       = "Convert Local CSV File To JSON"
  description = "Read a CSV file and transform it into JSON format."

  tags = {
    type = "featured"
  }

  # Input: Path to the CSV file
  param "local_csv_file_path" {
    type        = string
    description = "Path to the CSV file."
    default     = "./users.csv"
  }

  # Step: Transform CSV to JSON
  step "transform" "local_csv_file_to_json" {
    value = jsonencode(csvdecode(file("${param.local_csv_file_path}")))
  }

  # Outputs
  output "csv_contents" {
    description = "Contents of the local CSV file."
    value       = file("${param.local_csv_file_path}")
  }

  output "csv_decoded" {
    description = "Decoded data from the CSV file."
    value       = csvdecode(file("${param.local_csv_file_path}"))
  }

  output "csv_to_json" {
    description = "CSV file converted to JSON."
    value       = step.transform.local_csv_file_to_json.value
  }

}
