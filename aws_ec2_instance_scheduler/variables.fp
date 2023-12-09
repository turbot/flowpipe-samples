variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "teams_access_token" {
  description = "The Microsoft personal security access_token to authenticate to the Microsoft graph APIs."
  type        = string
}

variable "team_id" {
  description = "The unique identifier of the Team."
  type        = string
}
