variable "email_destination_list" {
  type        = list(string)
  description = "List of email addresses that will receive notifications."
}

variable "email_from" {
  type        = string
  description = "Email address that will be used as the sender."
}

variable "smtp_username" {
  type        = string
  description = "Username for the SMTP server."
}

variable "smtp_password" {
  type        = string
  description = "Password for the SMTP server."
}

variable "smtp_host" {
  type        = string
  description = "SMTP server host."
}

variable "smtp_port" {
  type        = number
  description = "SMTP server port."
}

variable "schedule" {
  type        = string
  description = "Schedule to look for changes. This may be a named interval (hourly, daily, weekly, 5m, 10m, 15m, 30m, 60m, 1h, 2h, 4h, 6h, 12h, 24h) or a custom schedule in cron syntax. Default is every 24 hours."
  default     = "daily"
}
