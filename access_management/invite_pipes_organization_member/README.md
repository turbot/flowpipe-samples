# Invite Pipes Organization Member

- Invite a member to an organization by email.
- Create a new workspace in an organization and bring in the organization member.
- Add organization member to an existing organization workspace.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd access_management/invite_pipes_organization_member
```

[Install mod dependencies](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Credentials

By default, the following environment variables will be used for authentication:

- `PIPES_TOKEN`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/pipes.fpc
```

```hcl
credential "pipes" "default" {
  token = "tpt_..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

## Usage

Run the pipeline and specify the necessary pipeline arguments:

- Send email invitation to users to join as member in the organization:

```sh
flowpipe pipeline run invite_organization_member_by_email --arg 'organization_handle=acme-demo' --arg 'email=acmeuser01@example.org'
```

- Create a new workspace in an organization and bring in the organization member.

```sh
flowpipe pipeline run create_organization_workspace_and_add_member --arg 'organization_handle=acme-demo' --arg 'workspace_handle=demoworkspace' --arg 'member_handle=acmeuser01-icbc'
```

- Add organization member to an existing organization workspace.

```sh
flowpipe pipeline run add_organization_member_to_workspace --arg 'organization_handle=acme-demo' --arg 'workspace_handle=demoworkspace' --arg 'member_handle=acmeuser01-icbc'
```
