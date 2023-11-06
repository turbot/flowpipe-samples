variable "token" {
  type        = string
  description = "API access token"
  default     = ""
  # TODO: Add once supported
  # sensitive  = true
}

variable "user_email" {
  type        = string
  description = "Email-id of the user."
  default     = ""
}

variable "api_base_url" {
  type        = string
  description = "API base URL."
  default     = ""
}

variable "project_key" {
  type        = string
  description = "The key identifying the project."
  default     = ""
}
