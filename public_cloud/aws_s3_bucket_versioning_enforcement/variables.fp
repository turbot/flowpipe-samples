variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = connection.aws.default
}

variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "schedule" {
  type        = string
  description = "Schedule to look for changes. This may be a named interval (hourly, daily, weekly, 5m, 10m, 15m, 30m, 60m, 1h, 2h, 4h, 6h, 12h, 24h) or a custom schedule in cron syntax. Default is every 24 hours."
  default     = "15m"
}

variable "notifier" {
  type        = notifier
  description = "Notifier to use."
  default     = notifier.default
}
