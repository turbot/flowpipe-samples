# CSV to JSON Converter

The CSV to JSON mod provides a convenient and efficient way to convert CSV data, such as from a local CSV file, local values or remote Google Sheet, into a JSON format.

## Usage

- Run the pipeline with the appropriate arguments.

- For a local csv file run, `flowpipe pipeline run local_csv_file_to_json --arg local_csv_file_path="/Users/bob/Desktop/students.csv"`

- For csv locals, update the locals.fp file and run `flowpipe pipeline run local_csv_values_to_json`

- For a remote Google Spreadsheet, run `flowpipe pipeline run remote_public_spreadsheet_to_json --arg spreadsheet_id="1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"`

- For a remote URL with csv data, run `flowpipe pipeline run remote_csv_url_to_json --arg url="https://data.nasa.gov/resource/nj3a-8wq3.csv"`
