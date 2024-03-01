variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "notifier" {
  type        = string
  description = "Notifier to use for alerting. This may be a named notifier (email, slack, etc). Defaults to slack."
  default     = "my_slack"
}
