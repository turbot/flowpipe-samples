variable "github_conn" {
  type        = connection.github
  description = "Name for GitHub connections to use. If not provided, the default connections will be used."
  default     = connection.github.default
}

variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS connections to use. If not provided, the default connections will be used."
  default     = connection.aws.default
}
