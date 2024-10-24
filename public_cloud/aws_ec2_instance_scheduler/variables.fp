variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_conn" {
  type        = connection.aws
  description = "Name for AWS connections to use. If not provided, the default connections will be used."
  default     = connection.aws.default
}

variable "teams_conn" {
  type        = connection.teams
  description = "Name for Teams connections to use. If not provided, the default connections will be used."
  default     = connection.teams.default
}

variable "team_id" {
  type        = string
  description = "The unique identifier of the team."
}

variable "teams_channel_id" {
  type        = string
  description = "The unique identifier for the Teams channel."
}
