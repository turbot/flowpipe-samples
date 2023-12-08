variable "sendgrid_cred" {
  type        = string
  description = "Name for SendGrid credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "hn_story_count" {
  type        = number
  description = "The number of stories to retrieve from Hacker News."
  default     = 50
}

variable "to" {
  type        = string
  description = "The intended recipient's email address."
}

variable "from" {
  type        = string
  description = "The 'From' email address used to deliver the message. This address should be a verified sender in your Twilio SendGrid account."
}
