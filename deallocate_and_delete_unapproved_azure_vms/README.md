# Deallocate And Delete Unapproved Azure VMs

Lists Azure VMs with a specific Tag values and checks them against the Approved List. If a VM with the desired Tag value is in running state and unapproved then it is deallocated. If a VM with the desired Tag value is in stopped/deallocated state and unapproved then it is deleted. For the deleted VMs, a Zendesk ticket is raised.

If run with `flowpipe server`, this mod will run the scan every day at 9 AM UTC.

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
cd public_cloud/deallocate_and_delete_unapproved_azure_vms
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `ZENDESK_API_TOKEN`
- `ZENDESK_EMAIL`
- `ZENDESK_SUBDOMAIN`

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
vi ~/.flowpipe/config/zendesk.fpc
```

```hcl
credential "zendesk" "default" {
  email      = "foo@bar.com"
  subdomain  = "bar"
  token      = "00B63........"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to run the scan immediately:

```sh
flowpipe pipeline run deallocate_and_delete_unapproved_azure_vms
```

To run the scan at the scheduled time, start the Flowpipe server:

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
subscription_id="sdfdsfdf-wxyz-1234-bbbb-529d4c76659c"
resource_group="sandbox"

# Optional
# azure_cred = "non_default_cred"
# zendesk_cred = "non_default_cred"
# tags_query = "[?tags.environment=='development' || tags.environment=='dev'].name"
```
