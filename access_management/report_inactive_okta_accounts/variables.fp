variable "jira_cred" {
  type        = string
  description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "okta_cred" {
  type        = string
  description = "Name for Oka credentials to use. If not provided, the default credentials will be used."
  default     = "default"
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
