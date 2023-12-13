# Paginate HTTP List Call Response

Paginate the response from HTTP list call.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd monitoring/http_list_pagination
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Credentials

No credentials are required.

### Usage

Run the pipeline to get paginated response from HTTP list call::

```sh
flowpipe pipeline run http_list_pagination'
```

### Configuration

No additional configuration is required.
