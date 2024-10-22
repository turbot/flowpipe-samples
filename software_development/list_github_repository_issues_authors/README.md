# Paginate HTTP List Call Response

List the authors of GitHub repository issues.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd software_development/list_github_repository_issues_authors
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Connections

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/github.fpc
```

```hcl
connection "github" "default" {
  token = "ghp_..."
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

### Usage

Run the pipeline to get list of GitHub repository issues authors:

```sh
flowpipe pipeline run list_github_repository_issues_authors --arg 'repository_owner=turbot' --arg 'repository_name=flowpipe' --arg 'issue_state=OPEN'
```

To use a specific `connection`, specify the `conn` pipeline argument:

```sh
flowpipe pipeline run list_github_repository_issues_authors --arg 'repository_owner=turbot' --arg 'repository_name=flowpipe' --arg 'issue_state=OPEN' --arg 'conn=connection.github.github_profile'
```

## Configuration

No additional configuration is required.
