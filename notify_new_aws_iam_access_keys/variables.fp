variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_access_key_id" {
  type        = string
  description = "The ID for this access key."
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
  sensitive   = true
}

variable "slack_token" {
  type        = string
  description = "Slack app token used to authenticate to your Slack workspace."
  sensitive   = true
}
