variable "slack_cred" {
  type        = string
  description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "channel" {
  type        = string
  description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
}

variable "text" {
  type        = string
  description = "The formatted text to describe the content of the message."
}
