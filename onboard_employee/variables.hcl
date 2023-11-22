variable "employee_email" {
  type        = string
  description = "The email address of the user to be onboarded."
}

variable "employee_name" {
  type        = string
  description = "The full name of the employee. Example: John Doe"
}

# GitHub
variable "github_access_token" {
  type        = string
  description = "The GitHub personal access token to authenticate to the GitHub APIs."
}

variable "github_repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe"
}

# Zendesk
variable "zendesk_api_token" {
  type        = string
  description = "The Zendesk personal access token to authenticate to the Zendesk."
}

variable "zendesk_subdomain" {
  type        = string
  description = "The subdomain to which the Zendesk account is associated to."
}

variable "zendesk_user_email" {
  type        = string
  description = "The email address of the user used to access the zendesk account."
}

# Gitlab
variable "gitlab_access_token" {
  type        = string
  description = "GitLab personal, project, or group access token to authenticate to the API. Example: glpat-ABC123_456-789."
  # TODO: Add once supported
  #sensitive  = true
}
