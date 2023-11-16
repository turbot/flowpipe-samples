# TODO: Remove all defaults once variables can be passed to mod dependencies properly
variable "gitlab_access_token" {
  type        = string
  description = "GitLab personal, project, or group access token to authenticate to the API. Example: glpat-ABC123_456-789."
  # TODO: Add once supported
  #sensitive  = true
}

variable "slack_token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  # TODO: Add once supported
  #sensitive  = true
  type = string
}

variable "slack_channel" {
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
  # TODO: Add once supported
  #sensitive  = true
  type = string
}
