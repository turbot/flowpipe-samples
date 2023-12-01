# Snapshot and Isolate GCP Compute Instance

For a given GCP Compute instance, create a snapshot for all of its disks, detach the disks, and then create ingress and egress firewall rules blocking all traffic.

## Usage

- Add your GCP credentials, project ID, and zone to `flowpipe.fpvars`
- Run the pipeline and specify `instance_name`, e.g., flowpipe pipeline run snapshot_isolate_gcp_compute_instance --arg 'instance_name=my_instance'
