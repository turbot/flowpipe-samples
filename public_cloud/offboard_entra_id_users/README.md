# Offboard Microsoft Entra ID Users

Suspend or disable accounts in Azure Active Directory after securing approval via Jira or email, and track all of the relevant information in a Jira ticket.

If run with `flowpipe server`, this mod will scan Jira for issues approving Entra ID user offboarding.

## Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd public_cloud/offboard_entra_id_users
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/azure.fpc
```

```hcl
credential "azure" "default" {
  client_id     = "<your client id>"
  client_secret = "<your client secret>"
  tenant_id     = "<your tenant id>"
}
```

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
credential "jira" "default" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to create a Jira issue to update Entra ID user status:

```sh
flowpipe pipeline run update_entra_id_user_status --arg user_id=a1b2c3d4-1234-ab12-ae19-xxx --arg account_status=disable --arg project_key=project-foo
```

To scan Jira issues to disable Entra ID user at the scheduled time, start the Flowpipe server:

```sh
flowpipe server
```

Once started, Flowpipe will run the pipeline automatically at the scheduled time.

## Configuration

To avoid entering variable values when running the pipeline or starting the server, you can set variable values:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
# Required
project_key    = "project-foo"

# Optional
# jira_cred = "non_default_cred"
# azure_cred = "non_default_cred"
```
