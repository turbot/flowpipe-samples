variable "teams_access_token" {
  description = "The Microsoft personal security access_token to authenticate to the Microsoft graph APIs."
  type        = string
}

variable "team_id" {
  description = "The unique identifier of the Team."
  type        = string
}

variable "jira_token" {
  type        = string
  description = "Jira API access token."
}

variable "jira_user_email" {
  type        = string
  description = "Email-id of the Jira user."
}

variable "jira_api_base_url" {
  type        = string
  description = "Jira API base URL."
}

variable "jira_project_key" {
  type        = string
  description = "The key identifying the Jira project."
}