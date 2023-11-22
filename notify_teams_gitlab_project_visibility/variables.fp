# TODO: Remove all defaults once variables can be passed to mod dependencies properly
variable "gitlab_access_token" {
  type        = string
  description = "GitLab personal, project, or group access token to authenticate to the API. Example: glpat-ABC123_456-789."
  # TODO: Add once supported
  #sensitive  = true
}

variable "teams_access_token" {
  description = "The Microsoft personal security access_token to authenticate to the Microsoft graph APIs."
  type        = string
  # TODO: Add once supported
  #sensitive  = true
}

variable "team_id" {
  description = "The unique identifier of the Team."
  type        = string
}
