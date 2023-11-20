// flowpipe pipeline run send_message_to_user_in_microsoft_teams --pipeline-arg subject="IMP MAIL" --pipeline-arg content="CONTENT" --pieline-arg user_email="cistest@turbotoffice.onmicrosoft.com"
pipeline "send_message_to_user_in_microsoft_teams" {
  title       = "Send Mail to specific Teams User"
  description = "Send an email to Teams user."

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

  step "pipeline" "get_user_by_email" {
    pipeline = teams.pipeline.get_user_by_email
    args = {
      access_token = param.access_token
      user_email   = param.user_email
    }
    error {
      ignore = true
    }
    // throw {
    //   if      = result.output.user == null
    //   message = "I am here!!!."
    // }
  }

  // step "echo" "test1" {
  //   text = step.pipeline.get_user_by_email
  // }

  // output "testout" {
  //   description = "Details."
  //   value       = step.echo.test1
  // }

  // If the user_email not found then send team > channel message

  step "pipeline" "send_channel_message" {
    if       = is_error(step.pipeline.get_user_by_email.output.user)
    pipeline = teams.pipeline.send_channel_message
    args = {
      access_token = param.access_token
      // team_id = param.team_id
      // channel_id = param.channel_id
      team_id    = "a85cca68-5844-40dd-a681-cd31b927a84f"
      channel_id = "19:caba4cc3cb924306b5bb643c5a78d515@thread.tacv2"
      // subject    = param.subject
      message = " ${param.user_email} Not Found."
    }
  }

  // If the user_email found then send team > channel message

  // step "pipeline" "send_channel_message" {
  //   if       = step.pipeline.get_user_by_email != null
  //   pipeline = teams.pipeline.send_channel_message
  //   args = {
  //     access_token = param.access_token
  //     // team_id = param.team_id
  //     // channel_id = param.channel_id
  //     team_id    = "a85cca68-5844-40dd-a681-cd31b927a84f"
  //     channel_id = "19:caba4cc3cb924306b5bb643c5a78d515@thread.tacv2"
  //     // subject    = param.subject
  //     message = " ${param.user_email} is updated with Email."
  //   }
  // }

  step "pipeline" "send_email" {
    if       = step.pipeline.get_user_by_email.output.user != null
    pipeline = teams.pipeline.send_email
    args = {
      access_token = param.access_token
      to_email     = ["${step.pipeline.get_user_by_email.output.user.userPrincipalName}"]
      subject      = param.subject
      content      = param.content
    }
  }

  output "testout" {
    description = "Details."
    value       = step.pipeline.get_user_by_email.output
  }

}
