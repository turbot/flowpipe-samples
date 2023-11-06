variable "token" {
  type        = string
  description = "API access token"
  # TODO: Add once supported
  # sensitive  = true
}

variable "user_email" {
  type        = string
  description = "Email-id of the user."
}

variable "api_base_url" {
  type        = string
  description = "API base URL."
}

variable "project_key" {
  type        = string
  description = "The key identifying the project."
}
