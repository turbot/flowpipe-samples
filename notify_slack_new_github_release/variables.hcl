variable "slack_channel" {
  type        = string
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
}

variable "slack_token" {
  type        = string
  description = "Slack app token used to authenticate to your Slack workspace."
  // TODO: Add once supported
  // sensitive  = true
}
