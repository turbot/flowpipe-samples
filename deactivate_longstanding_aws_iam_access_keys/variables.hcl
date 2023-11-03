variable "aws_region" {
  type        = string
  description = "The name of the Region."
  default     = ""
}

variable "aws_access_key_id" {
  type        = string
  description = "The ID for this access key."
  default     = ""
}

variable "aws_secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
  default     = ""
}
