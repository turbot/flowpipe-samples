variable "aws_region" {
  type        = string
  description = "The name of the Region."
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
  type        = string
  description = "The unique identifier of the team."
}

variable "teams_channel_id" {
  type        = string
  description = "The unique identifier for the Teams channel."
}
