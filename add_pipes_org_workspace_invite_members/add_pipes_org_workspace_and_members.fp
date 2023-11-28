pipeline "add_pipes_org_workspace_and_members" {
  title       = "Add Pipes Organization to Invite Members"
  description = "Add organization in pipe and invite members to join by email."

  param "token" {
    type        = string
    description = "API access token."
    default     = var.token
  }

  param "org_handle" {
    type        = string
    description = "The handle of the organization where the workspace has to be created."
  }

  param "workspace_handle" {
    type        = string
    description = "The handle name of the workspace to be created."
  }

  param "instance_type" {
    type        = string
    description = "The type of the instance to be created."
    default     = "db1.shared"
  }

  param "member_handles" {
    type        = list(string)
    description = "Orgnization member handles to be invited to join workspace."
    // Example ["rkforever-fbuq", "rkm2021"]
    // default = ["rkforever-fbuq", "rkm2021"]
  }

  param "role" {
    type        = string
    description = "The workspace role name assigned to the member. It supports reader, operator and owner as role."
    default     = "reader"
  }

  step "pipeline" "add_pipes_org_workspace" {
    pipeline = pipes.pipeline.create_org_workspace
    args = {
      token            = param.token
      org_handle       = param.org_handle
      workspace_handle = param.workspace_handle
      instance_type    = param.instance_type
    }
  }

  step "pipeline" "add_workspace_member" {
    depends_on = [step.pipeline.add_pipes_org_workspace]
    for_each   = { for handle in param.member_handles : handle => handle }
    pipeline   = pipes.pipeline.add_org_workspace_member
    args = {
      token            = param.token
      org_handle       = param.org_handle
      workspace_handle = param.workspace_handle
      role             = param.role
      member_handle    = each.value
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

