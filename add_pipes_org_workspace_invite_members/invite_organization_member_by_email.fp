pipeline "invite_organization_member_by_email" {
  title       = "Invite Members To Organization"
  description = "Invite members to the Pipes organization by email."

  param "pipes_credentials" {
    type        = string
    description = "Name for Pipes credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "organization_handle" {
    type        = string
    description = "The handle of the organization where the workspace has to be created."
  }

  param "email" {
    type        = list(string)
    description = "Email-ids of members to be invited to join organization."
    # Example ["test1@gmail.com", "test2@gmail.com"]
  }

  param "role" {
    type        = string
    description = "The role assigned to the member."
    default     = "member"
  }

  step "pipeline" "invite_organization_member_by_email" {
    for_each = { for email in param.email : email => email }
    pipeline = pipes.pipeline.invite_organization_member_by_email
    args = {
      cred       = param.pipes_credentials
      org_handle = param.organization_handle
      role       = param.role
      email      = each.value
    }
  }

  output "invitation_details" {
    description = "Invitation details."
    value       = step.pipeline.invite_organization_member_by_email
  }

}

