# AWS variables

variable "aws_cred" {
  type        = string
  description = "AWS credentials."
  default     = "default"
}

# Jira variables
variable "jira_cred" {
  type        = string
  description = "Jira credentials."
  default     = "default"
}

variable "jira_project_key" {
  type        = string
  description = "The key identifying the project."
}

variable "jira_issue_type" {
  type        = string
  description = "Jira issue type."
}
