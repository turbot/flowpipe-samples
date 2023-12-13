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

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

### Credentials

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi creds.fpc
```

```hcl
credential "github" "default" {
  token = "ghp_..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

### Usage

Run the pipeline to get list of GitHub repository issues authors:

```sh
flowpipe pipeline run list_github_repository_issues_authors
```

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
github_repository_full_name = "turbot/steampipe"
```