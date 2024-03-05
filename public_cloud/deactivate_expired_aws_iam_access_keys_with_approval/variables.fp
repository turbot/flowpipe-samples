variable "database" {
  type        = string
  description = "Steampipe database connection string."
  default     = "postgres://steampipe@localhost:9193/steampipe"
}

variable "notifier" {
  type        = string
  description = "Notifier to use."
  default     = "default"
}
