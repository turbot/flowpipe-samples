# Paginate HTTP List Call Response

List the authors of GitHub repository issues.

## Getting Started

### Credentials

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/github.fpc
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