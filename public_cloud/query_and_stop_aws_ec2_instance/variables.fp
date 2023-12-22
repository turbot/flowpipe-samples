variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_cred" {
  type        = string
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}
