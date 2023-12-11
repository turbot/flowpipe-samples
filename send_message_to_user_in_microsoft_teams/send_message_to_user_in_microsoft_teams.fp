pipeline "send_message_to_user_in_microsoft_teams" {
  title       = "Send Message to User in Teams"
  description = "Send an email to specific Team user and communicate to Team with a an update messge."

  tags = {
    type = "featured"
  }

  param "teams_cred" {
    type        = string
    description = "Name for Microsoft Teams credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "to_email" {
    type        = string
    description = "The email-id of the primary receipient."
  }

  param "subject" {
    type        = string
    description = "The subject of the email."
  }

  param "content" {
    type        = string
    description = "The content of the email."
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "channel_id" {
    type        = string
    description = "The channel's unique identifier."
    optional    = true
  }

  # Check if the user exists in Teams by to_email
  step "pipeline" "get_user_by_email" {
    pipeline = teams.pipeline.get_user_by_email

    args = {
      cred       = param.teams_cred
      user_email = param.to_email
    }

    # Exit pipeline, when the requested user is unavailable.
    throw {
      if      = result.output.status_code == 404
      message = "#### The requested user email is not found. Exiting the pipeline ####."
    }
  }

  # Get all members of the team
  step "pipeline" "list_team_members" {
    depends_on = [step.pipeline.get_user_by_email]

    pipeline = teams.pipeline.list_team_members

    args = {
      cred    = param.teams_cred
      team_id = param.team_id
    }
  }

  # Send email is the user is a member of the team
  step "pipeline" "send_mail" {
    depends_on = [step.pipeline.list_team_members]
    for_each   = { for user in step.pipeline.list_team_members.output.members : user.userId => user }
    if         = step.pipeline.get_user_by_email.output.user.id == each.key

    pipeline = teams.pipeline.send_mail

    args = {
      cred     = param.teams_cred
      to_email = ["${step.pipeline.get_user_by_email.output.user.userPrincipalName}"]
      subject  = param.subject
      content  = param.content
    }
  }

  # Update specific team > channel with a message that mail is communicated
  step "pipeline" "send_channel_message" {
    depends_on = [step.pipeline.send_mail]
    if         = param.channel_id != null

    pipeline = teams.pipeline.send_channel_message

    args = {
      cred       = param.teams_cred
      team_id    = param.team_id
      channel_id = param.channel_id
      message    = "Mail sent to ${step.pipeline.get_user_by_email.output.user.displayName}(${step.pipeline.get_user_by_email.output.user.userPrincipalName})."
    }
  }
}
