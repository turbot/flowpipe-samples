variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "schedule" {
  type        = string
  description = "Schedule to look for changes. This may be a named interval (hourly, daily, weekly, 5m, 10m, 15m, 30m, 60m, 1h, 2h, 4h, 6h, 12h, 24h) or a custom schedule in cron syntax. Default is every 24 hours."
  default     = "daily"
}

variable "notifier" {
  type        = string
  description = "Notifier to use for alerting. This may be a named notifier (email, slack, etc). Defaults to email."
  default     = "email"
}
