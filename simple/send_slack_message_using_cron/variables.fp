variable "slack_token" {
  type        = string
  description = "Slack app token used to authenticate to your Slack workspace."
}

 variable "slack_channel" {
    type        = string
    description = "Channel, private group, or IM channel to send message to."
  }

  variable "message" {
    type        = string
    description = "Message to be sent."
  }