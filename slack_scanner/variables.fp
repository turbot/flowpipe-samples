variable "slack_token" {
  description = "Slack app token used to authenticate to your Slack workspace."
  # TODO: Add once supported
  #sensitive  = true
  type = string
}

variable "slack_channel" {
  type        = string
  description = "Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name."
}
