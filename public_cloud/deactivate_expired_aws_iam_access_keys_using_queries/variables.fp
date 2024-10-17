variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "notifier" {
  type        = notifier
  description = "Notifier to use."
  default     = notifier.default
}
