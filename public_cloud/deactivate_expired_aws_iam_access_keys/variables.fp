variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS connections to use. If not provided, the default connection will be used."
  default     = connection.aws.default
}

variable "slack_conn" {
  type        = connection.slack
  description = "Name for Slack connections to use. If not provided, the default connection will be used."
  default     = connection.slack.default
}
