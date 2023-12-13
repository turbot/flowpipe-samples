pipeline "create_organization_workspace_and_add_member" {
  title       = "Create New Organization Workspace and Add Member"
  description = "Create a new workspace in an organization and bring in the organization member."

  param "pipes_cred" {
    type        = string
    description = "Name for Pipes credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "organization_handle" {
    type        = string
    description = "The handle of the organization where the workspace has to be created."
  }

  param "workspace_handle" {
    type        = string
    description = "The handle name of the workspace to be created."
  }

  param "instance_type" {
    type        = string
    description = "The type of the instance to be created. Supported values are 'db1.shared' and 'db1.small'."
    default     = "db1.shared"
  }

  param "member_handle" {
    type        = string
    description = "Orgnization member handles to be invited to join workspace."
  }

  param "role" {
    type        = string
    description = <<EOD
      The role for the new member at workspace level. Supported values are:

      reader: Has full read access to the workspace.
      operator: Has full read access to the workspace and can manage snapshots.
      owner: Has full administrative access to the workspace, aside from adding connections to the workspace which is reserved for org owners.
      EOD
    default     = "reader"
  }

  step "pipeline" "create_organization_workspace" {
    pipeline = pipes.pipeline.create_organization_workspace
    args = {
      cred                = param.pipes_cred
      handle              = param.workspace_handle
      instance_type       = param.instance_type
      organization_handle = param.organization_handle
    }
  }

  step "pipeline" "create_organization_workspace_member" {
    pipeline = pipes.pipeline.create_organization_workspace_member
    args = {
      cred             = param.pipes_cred
      handle           = param.member_handle
      org_handle       = param.organization_handle
      role             = param.role
      workspace_handle = step.pipeline.create_organization_workspace.output.organization_workspace.handle
    }
  }

  output "workspace" {
    description = "Workspace details."
    value       = step.pipeline.create_organization_workspace.output.organization_workspace
  }

  output "member" {
    description = "Member information."
    value       = step.pipeline.create_organization_workspace_member.output.member
  }
}
