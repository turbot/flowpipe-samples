variable "aws_cred" {
  type        = string
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "notifier" {
  type        = string
  description = "Notifier to use."
  default     = "default"
}

variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}
