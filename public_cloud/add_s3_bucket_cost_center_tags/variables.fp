variable "database" {
  type        = string
  description = "Steampipe database connection string."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "notifier" {
  type        = notifier
  description = "Notifier to use."
  default     = notifier.default
}

variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = connection.aws.default
}