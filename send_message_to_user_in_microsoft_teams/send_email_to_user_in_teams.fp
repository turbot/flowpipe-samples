# fpr send_email_to_user_in_teams --arg user_email="raj@turbotoffice.onmicrosoft.com" --arg subject="FP CLI Testing" --arg content="FOO"

pipeline "send_email_to_user_in_teams" {
  title       = "Send Mail to Specific Teams User"
  description = "Send an email to specific Team user and communicate to Team with a an update messge."

  param "access_token" {
    type        = string
    description = "The MS Team access token to use for the API request."
    default     = var.access_token
  }

  param "user_email" {
    type        = string
    description = "Email of the user."
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
    default     = var.team_id
  }

  // param "channel_id" {
  //   type        = string
  //   description = "The unique identifier for the channel."
  // }

  // Check if the user exists in Teams by email-id
  step "pipeline" "get_user_by_email" {
    pipeline = teams.pipeline.get_user_by_email
    args = {
      access_token = param.access_token
      user_email   = param.user_email
    }

    # When the requested channel is unavilable, exit the pipeline.
    throw {
      if      = result.output.status_code == 404
      message = "#### The requested user email is not found. Exiting the pipeline ####."
    }
  }

  // Debugging
  // output "usertest" {
  //   description = "The user details."
  //   value       = step.pipeline.get_user_by_email.output.user
  // }

  // output "errortest" {
  //   description = "The user details."
  //   value       = step.pipeline.get_user_by_email.output.error
  // }

  // If user existing above step then list members
  step "pipeline" "list_team_members" {
    depends_on = [step.pipeline.get_user_by_email]
    // if         = step.pipeline.get_user_by_email.output.user.userPrincipalName != null
    pipeline   = teams.pipeline.list_team_members
    args = {
      access_token = param.access_token
      team_id      = param.team_id
    }
  }

  // Send email when finds the userId match for the provided userPrincipalName i.e. abc@domain.onmicrosoft.com
  step "pipeline" "send_email" {
    depends_on = [step.pipeline.list_team_members]
    for_each   = { for user in step.pipeline.list_team_members.output.members.value : user.userId => user }
    if         = step.pipeline.get_user_by_email.output.user.id == each.key
    pipeline   = teams.pipeline.send_mail
    args = {
      access_token = param.access_token
      to_email     = ["${step.pipeline.get_user_by_email.output.user.userPrincipalName}"]
      subject      = param.subject
      content      = param.content
    }
  }

  // If the user_email not found then send team > channel message
  // step "pipeline" "send_channel_message" {
  //   if       = is_error(step.pipeline.get_user_by_email.output.user)
  //   pipeline = teams.pipeline.send_channel_message
  //   args = {
  //     access_token = param.access_token
  //     // team_id = param.team_id
  //     // channel_id = param.channel_id
  //     team_id    = "a85cca68-5844-40dd-a681-cd31b927a84f"
  //     channel_id = "19:caba4cc3cb924306b5bb643c5a78d515@thread.tacv2"
  //     message    = "${step.pipeline.get_user_by_email.output.user.displayName} with email-id as ${step.pipeline.get_user_by_email.output.user.userPrincipalName} is communicated."
  //   }
  // }

  // Update specific team > channel with a message that mail is communicated
  // step "pipeline" "send_channel_message" {
  //   depends_on = [step.pipeline.send_email]
  //   pipeline   = teams.pipeline.send_channel_message
  //   args = {
  //     access_token = param.access_token
  //     team_id      = param.team_id
  //     channel_id   = param.channel_id
  //     message      = "${step.pipeline.get_user_by_email.output.user.displayName} with email-id as ${step.pipeline.get_user_by_email.output.user.userPrincipalName} is communicated."
  //   }
  // }

}