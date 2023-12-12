# Summarize GitHub Issue with OpenAI

Summarize a GitHub issue with OpenAI.

### Credentials

By default, the following environment variables will be used for authentication:

- `GITHUB_TOKEN`
- `OPENAI_API_KEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/github.fpc
```

```hcl
credential "github" "default" {
  token = "ghp_..."
}
```

```sh
vi ~/.flowpipe/config/openai.fpc
```

```hcl
credential "openai" "default" {
  api_key = "sk-..."
}
```

### Configuration

You can configure your default repository by setting the `repository_full_name` variable:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
repository_full_name = "turbot/steampipe"
```

## Usage

Run the pipeline and specify the `issue_number` pipeline argument:

```sh
flowpipe pipeline run summarize_github_issue_with_openai --arg 'issue_number=3997'
```
