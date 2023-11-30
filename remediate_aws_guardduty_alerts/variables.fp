# AWS variables

variable "region" {
  type        = string
  description = "The name of the Region."
}

variable "access_key_id" {
  type        = string
  description = "The ID for this access key."
}

variable "secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
}

# Jira variables

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
