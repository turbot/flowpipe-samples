# Transform Data in Google Spreadsheet

Find and replace text across all google spreadsheets.

## Usage

- Add your access token to `flowpipe.pvars`. Refer [here](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/print-access-token), how to generate access token
- Run the pipeline and specify required tex in `find_text` and `replace_text`, e.g.,

    ```
    flowpipe pipeline run find_replace_text_in_googlesheets --arg find_text="APPLE" --arg replace_text="ORANGE"
    ```