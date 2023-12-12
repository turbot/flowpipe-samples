variable "aws_region" {
  type        = string
  description = "The name of the Region."
  default     = "us-east-1"
}

variable "github_repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe."
}

variable "github_cred" {
  type        = string
  description = "Name for GitHub credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "aws_cred" {
  type        = string
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}
