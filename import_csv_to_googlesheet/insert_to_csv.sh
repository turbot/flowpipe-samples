#!/bin/bash
ACCESS_TOKEN="ya29.a0AfB_byDbTEtwNzLKvIkkz7IKy8zKtLnTGzmM24kio4OxQjSp_8HCrzFASW5GVhoKCcgjMidJK2EoV2bw_D9dbqVF3B14ZfdXivEQzVwWj_fM12IjniOzEDA7D-ROUFT8tYylNm_SL6bzQQuE-G_3nxNySzwgtl4B7hWhaCgYKARgSARISFQHGX2MimYn4KdPCtNR31jB39AfsRQ0171"  # Replace with your actual access token
SPREADSHEET_ID="1nWwobAcyVOf36AtZVP3bPN4Ul0ttCuKLLV7o-8MLTzE"  # Replace with your actual spreadsheet ID
RANGE="Sheet1!A:M"  # Replace with the target range in your sheet

CSV_FILE_PATH="industry_sic.csv"  # Replace with your actual CSV file path

# Read the CSV data into a JSON array
JSON_ARRAY=$(tail -n +2 "$CSV_FILE_PATH" | jq -R -s -c 'split("\n") | map(split(","))')

# Make the API request to append data
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw "{\"values\": $JSON_ARRAY}" \
  "https://sheets.googleapis.com/v4/spreadsheets/$SPREADSHEET_ID/values/$RANGE:append?valueInputOption=RAW"
