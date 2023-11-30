# Snapshot and Isolate GCP Compute Instance

Capturing instance state with Snapshot, detaching disks, and enforcing isolation with firewall rules for enhanced security in Google Cloud.

## Usage

- Add your GCP credentials, project ID, and zone to `flowpipe.fpvars`
Run the pipeline and specify `instance_name`, e.g., flowpipe pipeline run secure_snapshot_gcp_instance --arg 'instance_name=my_instance'
