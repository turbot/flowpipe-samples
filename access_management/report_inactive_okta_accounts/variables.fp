variable "jira_conn" {
  type        = connection.jira
  description = "Name for Jira connections to use. If not provided, the default connections will be used."
  default     = connection.jira.default
}

variable "okta_conn" {
  type        = connection.okta
  description = "Name for Oka connections to use. If not provided, the default connections will be used."
  default     = connection.okta.default
}

variable "inactive_hours" {
  type        = number
  description = "Number of hours of inactivity before an account is deactivated."
}

variable "issue_type" {
  type        = string
  description = "Issue type."
}

variable "project_key" {
  type        = string
  description = "The key identifying the jira project."
}
