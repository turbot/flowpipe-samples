variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_access_key_id" {
  type        = string
  description = "The ID for this access key."
}

variable "aws_secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
}

variable "slack_channel" {
  type        = string
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
}

variable "slack_token" {
  type        = string
  description = "Slack app token used to authenticate to your Slack workspace."
}
