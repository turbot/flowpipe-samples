pipeline "local_csv_values_to_json" {
  title       = "Local CSV Values To JSON"
  description = "Read CSV data from locals and convert the contents to JSON."

  # Using local CSV values
  step "transform" "local_csv_values_to_json" {
    value = jsonencode(csvdecode(local.csv_data))
  }

  output "local_csv_values_to_json" {
    value = step.transform.local_csv_values_to_json.value
  }
}
