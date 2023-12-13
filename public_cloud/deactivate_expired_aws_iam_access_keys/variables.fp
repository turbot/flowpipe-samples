variable "aws_cred" {
  type        = string
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "slack_cred" {
  type        = string
  description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}
