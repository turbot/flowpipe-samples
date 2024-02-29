variable "slack_channel" {
  type        = string
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
}

variable "slack_cred" {
  type        = string
  description = "Name for Slack credentials to use. If not provided, the default credentials will be used."
}