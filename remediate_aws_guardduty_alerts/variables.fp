# AWS variables

variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_access_key_id" {
  type        = string
  description = "The ID for this access key."
}

variable "aws_secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
}

# Jira variables

variable "jira_token" {
  type        = string
  description = "Jira API token."
}

variable "jira_user_email" {
  type        = string
  description = "Jira user email."
}

variable "jira_api_base_url" {
  type        = string
  description = "API base URL."
}

variable "jira_project_key" {
  type        = string
  description = "The key identifying the project."
}
