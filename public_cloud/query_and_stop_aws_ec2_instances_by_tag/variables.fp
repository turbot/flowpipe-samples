variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = connection.aws.default
}