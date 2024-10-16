variable "sendgrid_conn" {
  type        = connection.sendgrid
  description = "Name for SendGrid connections to use. If not provided, the default connection will be used."
  default     = connection.sendgrid.default
}

variable "hn_story_count" {
  type        = number
  description = "The number of stories to retrieve from Hacker News."
  default     = 2
}

variable "to" {
  type        = string
  description = "The intended recipient's email address."
}

variable "from" {
  type        = string
  description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
}

variable "database" {
  type        = connection.steampipe
  description = "Steampipe database connection string."
  default     = connection.steampipe.default
}