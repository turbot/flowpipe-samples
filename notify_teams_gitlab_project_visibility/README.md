# Notify Teams on GitLab Public Projects, Optionally Update Public Projects To Private

Notify a Teams channel with GitLab Public Projects of a group. Optionally, update the public projects in the group to private.

## Getting Started
### Credentials

By default, the following environment variables will be used for authentication:

- `GITLAB_TOKEN`
- `TEAMS_ACCESS_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/gitlab.fpc
```

```hcl
credential "gitlab" "default" {
  token = "glpat-..."
}
```

```sh
vi ~/.flowpipe/config/teams.fpc
```

```hcl
credential "teams" "default" {
  access_token = "bfc6f1c42dsfsdfdxxxx26977977b2xxxsfsdda98f313c3d389126de0d"
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline to make public GitLab project to private and notify in Microsoft teams channel

```sh
flowpipe pipeline run notify_teams_gitlab_project_visibility --arg team_id=111aaa00-abcd-efgh-1234-000aaa111bbb --arg teams_channel_id="19:P7fSYEJGuWSTHTfYAMAZEzIc1Uk8BTS-abcdnSV2H-A1@thread.tacv2" --arg group_id=8937 --arg action_public_to_private=true
```