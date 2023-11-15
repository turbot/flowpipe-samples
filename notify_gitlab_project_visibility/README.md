# Notify Slack on GitLab Prublic Projects, Optionally update the public projects to private

Notify a Slack channel with GitLab Public Projects in a group. Optionally, update the public projects in the group to private.

## Usage

- Add your Slack API token and channel name to `flowpipe.pvars`
- Add your GitLab API token to `flowpipe.pvars`
- Start your Flowpipe server
- Run the pipeline and specify `group_id` and `action_public_to_private`, e.g., `flowpipe pipeline run notify_gitlab_project_visibility --pipeline-arg group_id=77637670`
- You can update the public projects to private with `--pipeline-arg action_public_to_private=true`
