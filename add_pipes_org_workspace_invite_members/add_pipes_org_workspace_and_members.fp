pipeline "add_pipes_org_workspace_and_members" {
  title       = "Add Pipes Workspace Organization and Add Members"
  description = "Create a workspace in an organization and bring in organization members to the workspace."

  param "pipes_credentials" {
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

  param "member_handles" {
    type        = list(string)
    description = "Orgnization member handles to be invited to join workspace."
    # ["rk-fbuq", "rkm2023"]
  }

  param "role" {
    type        = string
    description = "The workspace role name assigned to the member. It supports reader, operator and owner as role."
    default     = "reader"
  }

  step "pipeline" "add_pipes_org_workspace" {
    pipeline = pipes.pipeline.create_organization_workspace
    args = {
      cred                = param.pipes_credentials
      organization_handle = param.organization_handle
      handle              = param.workspace_handle
      instance_type       = param.instance_type
    }
  }

  step "pipeline" "add_workspace_member" {
    depends_on = [step.pipeline.add_pipes_org_workspace]
    for_each   = { for handle in param.member_handles : handle => handle }
    pipeline   = pipes.pipeline.create_organization_workspace_member
    args = {
      cred             = param.pipes_credentials
      org_handle       = param.organization_handle
      workspace_handle = param.workspace_handle
      role             = param.role
      handle           = each.value
    }
  }

  output "workspace" {
    description = "Workspace details."
    value       = step.pipeline.add_pipes_org_workspace
  }

  output "member" {
    description = "Member information."
    value       = step.pipeline.add_workspace_member
  }

}
