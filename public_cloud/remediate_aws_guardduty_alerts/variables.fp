# AWS variables

variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

# Jira variables

variable "jira_project_key" {
  type        = string
  description = "The key identifying the project."
}
