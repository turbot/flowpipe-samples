variable "aws_region" {
  type        = string
  description = "The name of the Region."
  default     = "us-east-1"
}

variable "github_repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe."
}
