pipeline "add_organization_member_to_workspace" {
  title       = "Add Organization Member to Workspace"
  description = "Add organization member to an existing organization workspace."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.pipes
    description = "Name of Pipes connection to use. If not provided, the default Pipes connection will be used."
    default     = connection.pipes.default
  }

  param "organization_handle" {
    type        = string
    description = "Specify the handle of the organization where the workspace lives."
  }

  param "workspace_handle" {
    type        = string
    description = "Specify the handle of the workspace where the member need to be invited."
  }

  param "member_handle" {
    type        = list
    description = "Orgnization member handle to be invited to join workspace."
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

  step "pipeline" "create_organization_workspace_member" {
    pipeline = pipes.pipeline.create_organization_workspace_member
    args = {
      conn             = param.conn
      handle           = param.member_handle
      org_handle       = param.organization_handle
      role             = param.role
      workspace_handle = param.workspace_handle
    }
  }

  output "member" {
    description = "Member information."
    value       = step.pipeline.create_organization_workspace_member.output.member
  }
}
