variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_cred" {
  type        = string
  description = "Name for AWS credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "teams_cred" {
  type        = string
  description = "Name for Teams credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "team_id" {
  description = "Team ID"
  type        = string
}

variable "teams_channel_id" {
  description = "Teams Channel ID"
  type        = string
}
