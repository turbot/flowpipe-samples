pipeline "onboard_employee" {
  title       = "Onboard Employee"
  description = "Onboard an Employee onto multiple platforms."

  param "employee_name" {
    type        = string
    description = "The full name of the employee. Example: John Doe"
    default     = var.employee_name
  }

  param "employee_email" {
    type        = string
    description = "The email address of the employee."
    default     = var.employee_email
  }

  param "tools_needed" {
    type        = list(string)
    description = "List of tools to which the Employee needs to be added.Example: github, zendesk."
  }

  # GitHub
  param "github_access_token" {
    type        = string
    description = "The GitHub personal access token to authenticate to the GitHub APIs."
    default     = var.github_access_token
  }

  param "github_organization" {
    type        = string
    description = "The organization name. The name is not case sensitive."
  }

  param "github_role" {
    type        = string
    description = <<EOD
      "The role for the new member."
        `admin` - Organization owners with full administrative rights to the organization and complete access to all repositories and teams.
        `direct_member` - Non-owner organization members with ability to see other members and join teams by invitation.
        `billing_manager` - Non-owner organization members with ability to manage the billing settings of your organization."
      EOD
    default     = "direct_member"
  }

  # Zendesk
  param "zendesk_api_token" {
    type        = string
    description = "The Zendesk personal access token to authenticate to the Zendesk."
    default     = var.zendesk_api_token
  }

  param "zendesk_user_email" {
    type        = string
    description = "Email address of agent user who has permission to access the API. This is the email address inviting the new employee."
    default     = var.zendesk_user_email
  }

  param "zendesk_subdomain" {
    type        = string
    description = "The subdomain to which the Zendesk account is associated to."
    default     = var.zendesk_subdomain
  }

  param "zendesk_role" {
    type        = string
    description = "The role of the user created."
    default     = "end-user"
  }

  # Gitlab
  param "gitlab_access_token" {
    type = string
    # description = local.access_token_param_description
    default = var.gitlab_access_token
  }

  param "gitlab_group_id" {
    type        = string
    description = "The ID or URL-encoded path of the group owned by the authenticated user."
  }

  param "gitlab_access_level" {
    type = string
    # https://docs.gitlab.com/ee/api/members.html#valid-access-levels
    description = <<EOD
      "A valid access level (defaults: 30, the Developer role)."
        * No access (0)
        * Minimal access (5) (Introduced in GitLab 13.5.)
        * Guest (10)
        * Reporter (20)
        * Developer (30)
        * Maintainer (40)
        * Owner (50). Valid for projects in GitLab 14.9 and later.
    EOD
  }

  step "pipeline" "github_create_organization_invitation" {
    if       = contains(param.tools_needed, "github")
    pipeline = github.pipeline.create_organization_invitation
    args = {
      access_token = param.github_access_token
      organization = param.github_organization
      email        = param.employee_email
      role         = param.github_role
    }
  }

  step "pipeline" "zendesk_create_user" {
    if       = contains(param.tools_needed, "zendesk")
    pipeline = zendesk.pipeline.create_user
    args = {
      api_token  = param.zendesk_api_token
      user_email = param.zendesk_user_email
      subdomain  = param.zendesk_subdomain
      email      = param.employee_email
      name       = param.employee_name
      role       = param.zendesk_role
    }
  }

  step "pipeline" "gitlab_create_group_invitation" {
    if       = contains(param.tools_needed, "gitlab")
    pipeline = pipeline.create_group_invitation
    args = {
      api_token    = param.gitlab_access_token
      email        = param.employee_email
      group_id     = param.gitlab_group_id
      access_level = param.gitlab_access_level
    }
  }

  output "github_invitation" {
    value = contains(param.tools_needed, "github") ? step.pipeline.github_create_organization_invitation.output.invitation : null
  }

  output "zendesk_user" {
    value = contains(param.tools_needed, "zendesk") ? step.pipeline.zendesk_create_user.output.user : null
  }

  output "onboard_employee" {
    value = {
      github  = contains(param.tools_needed, "github") ? step.pipeline.github_create_organization_invitation.output.invitation : null
      gitlab  = contains(param.tools_needed, "gitlab") ? step.pipeline.gitlab_create_group_invitation.output.invitation : null
      zendesk = contains(param.tools_needed, "zendesk") ? step.pipeline.zendesk_create_user.output.user : null
    }
  }
}

pipeline "create_group_invitation" {
  title       = "Create Group Invitation"
  description = "Adds a new member."

  param "access_token" {
    type = string
    # description = local.access_token_param_description
    default = var.gitlab_access_token
  }

  param "group_id" {
    type        = string
    description = "The ID or URL-encoded path of the group owned by the authenticated user."
  }

  param "email" {
    type        = string
    description = "The email of the new member."
  }

  param "access_level" {
    type = string
    # https://docs.gitlab.com/ee/api/members.html#valid-access-levels
    description = <<EOD
      "A valid access level (defaults: 30, the Developer role)."
        * No access (0)
        * Minimal access (5) (Introduced in GitLab 13.5.)
        * Guest (10)
        * Reporter (20)
        * Developer (30)
        * Maintainer (40)
        * Owner (50). Valid for projects in GitLab 14.9 and later.
    EOD
  }

  step "http" "create_group_invitation" {
    method = "post"
    url    = "https://gitlab.com/api/v4/groups/${param.group_id}/invitations"


    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    request_body = jsonencode({
      access_level = param.access_level
      email        = param.email
    })
  }

  output "invitation" {
    description = "Invitation details."
    value       = step.http.create_group_invitation.response_body
  }
}
