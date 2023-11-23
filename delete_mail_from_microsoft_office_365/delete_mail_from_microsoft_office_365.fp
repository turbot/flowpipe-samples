pipeline "delete_mail_from_microsoft_office_365" {
  title       = "Delete Email From Microsoft Office 365"
  description = "Delete an email from a specified user's mailbox in Microsoft Office 365."

  param "teams_access_token" {
    type        = string
    description = "The MS Team access token to use for the API request."
    default     = var.teams_access_token
  }

  param "user_id" {
    type        = string
    description = "The unique identifier for the user."
  }

  param "message_id" {
    type        = string
    description = "The email message ID which needs to be deleted."
  }

  # Get an Email
  step "pipeline" "get_email" {
    pipeline = teams.pipeline.get_email
    args = {
      token      = param.teams_access_token
      user_id    = param.user_id
      message_id = param.message_id
    }
  }

  # Delete an Email
  step "pipeline" "delete_email" {
    depends_on = [step.pipeline.get_email]
    pipeline   = teams.pipeline.delete_email
    args = {
      token      = param.teams_access_token
      user_id    = param.user_id
      message_id = param.message_id
    }
  }

  output "deleted_mail" {
    value       = step.pipeline.get_email.output.get_mail
    description = "The deleted email details."
  }
}