variable "gitlab_access_token" {
  type        = string
  description = "GitLab personal, project, or group access token to authenticate to the API. Example: glpat-ABC123_456-789."
}

variable "teams_access_token" {
  description = "The Microsoft personal security access_token to authenticate to the Microsoft graph APIs."
  type        = string
}

variable "team_id" {
  description = "The unique identifier of the Team."
  type        = string
}
