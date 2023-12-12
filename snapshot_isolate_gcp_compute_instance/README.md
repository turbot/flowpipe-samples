# Snapshot and Isolate GCP Compute Instance

For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic.

## Usage

- Set your `GOOGLE_APPLICATION_CREDENTIALS` environment variable or configure your GCP credentials in `~/.flowpipe/config/gcp.fpc`:
  ```hcl
  credential "gcp" "gcp_cred" {
    credentials = "path/to/credentials.json"
  }
  ```
- Run the pipeline and specify `instance_name`, e.g., `flowpipe pipeline run snapshot_isolate_gcp_compute_instance --arg 'instance_name=instance-1'`

**Note:** If no environment variables or configuration files are found, the mod will attempt to use [Application Default Credentials](https://cloud.google.com/docs/authentication/provide-credentials-adc) if configured.