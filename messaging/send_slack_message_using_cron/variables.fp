variable "slack_conn" {
  type        = connection.slack
  description = "Name for Slack connections to use. If not provided, the default connection will be used."
  default     = connection.slack.default
}

variable "channel" {
  type        = string
  description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
}

variable "text" {
  type        = string
  description = "The formatted text to describe the content of the message."
}
