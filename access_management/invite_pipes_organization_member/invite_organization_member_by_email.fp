pipeline "invite_organization_member_by_email" {
  title       = "Invite Organization Member by Email"
  description = "Invite a member to an organization by email."

  tags = {
    type = "featured"
  }

  param "pipes_cred" {
    type        = string
    description = "Name for Pipes credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "organization_handle" {
    type        = string
    description = "Specify the handle of an organization where the member need to be invited."
  }

  param "email" {
    type        = string
    description = "Email-id of the member to be invited."
  }

  param "role" {
    type        = string
    description = <<EOD
      The role for the new member at organization level. Supported values are:

      member: Can be granted permissions in workspaces and see members of the organization.
      owner: Has full administrative rights to the organization including complete access to all workspaces, connections, users, groups and permissions.
      EOD
    default     = "member"
  }

  step "pipeline" "invite_organization_member_by_email" {
    pipeline = pipes.pipeline.invite_organization_member_by_email
    args = {
      cred       = param.pipes_cred
      org_handle = param.organization_handle
      role       = param.role
      email      = param.email
    }
  }

  output "invitation_details" {
    description = "Invitation details."
    value       = step.pipeline.invite_organization_member_by_email
  }
}
