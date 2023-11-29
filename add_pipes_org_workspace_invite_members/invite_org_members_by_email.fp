pipeline "invite_org_members_by_email" {
  title       = "Invite Members to Organization"
  description = "Add members by email invite to the organization in pipe."

  param "token" {
    type        = string
    description = "API access token."
    default     = var.token
  }

  param "org_handle" {
    type        = string
    description = "The handle of the organization where the workspace has to be created."
  }

  param "member_email" {
    type        = list(string)
    description = "Email-ids of members to be invited to join organization."
    # Example ["test1@gmail.com", "test2@gmail.com"]
  }

  param "role" {
    type        = string
    description = "The role assigned to the member."
    default     = "member"
  }

  step "pipeline" "invite_org_members_by_email" {
    for_each = { for email in param.member_email : email => email }
    pipeline = pipes.pipeline.invite_org_member_by_email
    args = {
      token      = param.token
      org_handle = param.org_handle
      role       = param.role
      email      = each.value
    }
  }

  output "invitation_details" {
    description = "Invitation details."
    value       = step.pipeline.invite_org_members_by_email
  }

}

