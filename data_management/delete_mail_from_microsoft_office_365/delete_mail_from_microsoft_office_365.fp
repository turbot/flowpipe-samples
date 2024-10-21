pipeline "delete_mail_from_microsoft_office_365" {
  title       = "Delete Mail From Microsoft Office 365"
  description = "Delete an email from a specified user's mailbox in Microsoft Office 365."

  tags = {
    type = "featured"
  }

  param "conn" {
    type        = connection.teams
    description = "Name of Teams connection to use. If not provided, the default Teams connection will be used."
    default     = connection.teams.default
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
    pipeline = teams.pipeline.get_message
    args = {
      conn       = param.conn
      user_id    = param.user_id
      message_id = param.message_id
    }
  }

  # Delete an Email
  step "pipeline" "delete_email" {
    depends_on = [step.pipeline.get_email]
    pipeline   = teams.pipeline.delete_message
    args = {
      conn       = param.conn
      user_id    = param.user_id
      message_id = param.message_id
    }
  }

  output "deleted_mail" {
    value       = step.pipeline.get_email.output.message
    description = "The deleted email details."
  }
}
