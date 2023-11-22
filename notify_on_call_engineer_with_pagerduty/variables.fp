variable "pagerduty_api_token" {
  type        = string
  description = "PagerDuty API token used for authentication, e.g., `y_NbAkKc66ryYTWUXYEu`."
  // TODO: Add once supported
  // sensitive  = true
  default = ""
}

variable "slack_api_token" {
  type        = string
  description = "Slack app token used to authenticate to your Slack workspace."
  // TODO: Add once supported
  // sensitive  = true
  default = ""
}

variable "slack_channel" {
  type        = string
  description = "Encoded ID or name of the Slack channel to send the message. Encoded ID is recommended. Examples: C1234567890, general, random"
  # TODO: Add once supported
  #sensitive  = true
  default = ""
}

variable "sendgrid_api_key" {
  type        = string
  description = "The SendGrid access api_key to authenticate to the OpenAI APIs, e.g., `SG.ABCDEFGHIJ-a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16q17r18s19t20u21v`."
  // TODO: Add once supported
  // sensitive  = true
  default = ""
}