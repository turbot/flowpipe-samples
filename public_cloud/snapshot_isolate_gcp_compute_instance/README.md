# Snapshot and Isolate GCP Compute Instance

For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic.

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
cd public_cloud/snapshot_isolate_gcp_compute_instance
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:


- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`
- `GOOGLE_APPLICATION_CREDENTIALS`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
connection "jira" "jira_conn" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

```sh
vi ~/.flowpipe/config/gcp.fpc
```

```hcl
connection "gcp" "gcp_conn" {
  credentials = "path/to/credentials.json"
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

- Run the pipeline and specify `gcp_project_id`, `gcp_instance_name`, `jira_project_key`, `jira_issue_type` pipeline arguments: 

```sh
flowpipe pipeline run snapshot_isolate_gcp_compute_instance --arg 'gcp_instance_name=flowpipe-test' --arg 'gcp_project_id=parker-aaa' --arg 'jira_project_key=SBT' --arg 'jira_issue_type=Task'
```

**Note:** If no environment variables or configuration files are found, the mod will attempt to use [Application Default Connections](https://cloud.google.com/docs/authentication/provide-credentials-adc) if configured.