# CSV to JSON Converter

The CSV to JSON mod provides a convenient and efficient way to convert CSV data from a local CSV file into a JSON format.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd productivity/csv_to_json
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

No credentials are required.

## Usage

Run the pipeline and specify the `local_csv_file_path` pipeline arguments:

```sh
flowpipe pipeline run local_csv_file_to_json --arg local_csv_file_path="/Users/bob/Desktop/students.csv"
```
