# AWS variables

variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_conn" {
  type        = connection.aws
  description = "AWS connections."
  default     = connection.aws.default
}

# Jira variables
variable "jira_conn" {
  type        = connection.jira
  description = "Jira connections."
  default     = connection.jira.default
}

variable "jira_project_key" {
  type        = string
  description = "The key identifying the project."
}

variable "jira_issue_type" {
  type        = string
  description = "Jira issue type."
}
