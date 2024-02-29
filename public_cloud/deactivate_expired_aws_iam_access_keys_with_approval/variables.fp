variable "database" {
  type        = string
  description = "Database to connect to."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "notifier" {
  type        = string
  description = "Notifier to use."
  default     = "default"
}
