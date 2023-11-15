pipeline "notify_gitlab_project_visibility" {
  title       = "Notify GitLab Project Visibility Changes"
  description = "Notify a Slack channel when a GitLab's project visibility is changed."

  param "gitlab_access_token" {
    type        = string
    description = "GitLab personal, project, or group access token to authenticate to the API. Example: glpat-ABC123_456-789."
    default     = var.gitlab_access_token
  }

  param "group_id" {
    type        = string
    description = "GitLab Group ID"
  }

  param "slack_token" {
    type        = string
    default     = var.slack_token
    description = "Authentication token for Slack bearing required scopes."
  }

  param "slack_channel" {
    type        = string
    default     = var.slack_channel
    description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
  }

  param "unfurl_links" {
    type        = bool
    default     = false
    description = "Pass true to enable unfurling of primarily text-based content."
  }

  param "unfurl_media" {
    type        = bool
    default     = false
    description = "Pass false to disable unfurling of media content."
  }

  step "pipeline" "list_group_projects" {
    pipeline = gitlab.pipeline.list_group_projects

    args = {
      access_token = param.gitlab_access_token
      group_id     = param.group_id
      visibility   = "public"
    }
  }

  step "pipeline" "post_message" {
    pipeline = slack.pipeline.post_message
    args = {
      token        = param.slack_token
      channel      = param.slack_channel
      unfurl_links = param.unfurl_links
      unfurl_media = param.unfurl_media
      message      = <<-EOT

    Unapproved Public Projects:

    ${join("\n", [for project in step.pipeline.list_group_projects.output.group_projects : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project.id), project.name, project.path_with_namespace, project.web_url, project.visibility) if !contains(local.approved_public_projects, project.id)])}
    EOT
    }
  }
}
