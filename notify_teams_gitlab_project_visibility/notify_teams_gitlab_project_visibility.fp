pipeline "notify_teams_gitlab_project_visibility" {
  title       = "Notify GitLab Project Visibility Changes"
  description = "Notify in a Microsoft Teams channel whenever there is a change in the visibility status of a GitLab project."

  tags = {
    type = "featured"
  }

  param "gitlab_cred" {
    type        = string
    description = "Name for GitLab credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "group_id" {
    type        = string
    description = "GitLab Group ID."
  }

  param "action_public_to_private" {
    type        = bool
    description = "Pass true to make unapproved public projects to private."
    default     = false
  }

  param "teams_cred" {
    type        = string
    description = "Name for Microsoft Teams credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "team_id" {
    type        = string
    description = "The unique identifier of the team."
  }

  param "teams_channel_id" {
    type        = string
    description = "The unique identifier for the channel."
  }

  step "pipeline" "list_group_projects" {
    pipeline = gitlab.pipeline.list_group_projects

    args = {
      cred       = param.gitlab_cred
      group_id   = param.group_id
      visibility = "public"
    }
  }

  step "pipeline" "update_project_visibility" {
    if = param.action_public_to_private == true && length(step.pipeline.list_group_projects.output.group_projects) > 0
    for_each = {
      for project in step.pipeline.list_group_projects.output.group_projects : project.name => project
      if !contains(local.approved_public_projects, project.id)
    }
    pipeline = gitlab.pipeline.update_project

    args = {
      cred       = param.gitlab_cred
      visibility = "private"
      project_id = tostring(each.value.id)
    }
  }

  step "pipeline" "send_message" {
    pipeline = teams.pipeline.send_channel_message
    args = {
      cred                 = param.teams_cred
      team_id              = param.team_id
      channel_id           = param.teams_channel_id
      message_content_type = "html"
      message              = <<-EOT
      <b>Public Projects</b>:<br/>
      ${join("<br/>", [for project in step.pipeline.list_group_projects.output.group_projects : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project.id), project.name, project.path_with_namespace, project.web_url, project.visibility)])}
      <br/><b>Approved Public Projects</b>:<br/>
      ${join("<br/>", [for project in step.pipeline.list_group_projects.output.group_projects : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project.id), project.name, project.path_with_namespace, project.web_url, project.visibility) if contains(local.approved_public_projects, project.id)])}
      <br/><b>Projects updated to Private visibility</b>:<br/>
      ${coalesce(join("<br/>", [for project, project_details in step.pipeline.update_project_visibility : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project_details.output.project.id), project_details.output.project.name, project_details.output.project.path_with_namespace, project_details.output.project.web_url, project_details.output.project.visibility)]), "None")}
      EOT
    }
  }

  output "public_projects" {
    description = "List of all public projects in the group."
    value       = [for project in step.pipeline.list_group_projects.output.group_projects : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project.id), project.name, project.path_with_namespace, project.web_url, project.visibility)]
  }

  output "approved_public_project_ids" {
    description = "List of Approved public project Ids in the group."
    value       = [for project in step.pipeline.list_group_projects.output.group_projects : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project.id), project.name, project.path_with_namespace, project.web_url, project.visibility) if contains(local.approved_public_projects, project.id)]
  }

  output "updated_projects" {
    description = "List of Projects that are updated from Public to Private visibility."
    value       = [for project, project_details in step.pipeline.update_project_visibility : format("Project_Id:%s, Project_Name:%s, Namespace:%s, Web_URL:%s, Visibility:%s", tostring(project_details.output.project.id), project_details.output.project.name, project_details.output.project.path_with_namespace, project_details.output.project.web_url, project_details.output.project.visibility)]
  }

}
