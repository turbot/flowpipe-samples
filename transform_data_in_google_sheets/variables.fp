variable "code" {
  description = "The authorization code generated for accessing the token."
  type        = string
  # TODO: Add once supported
  # sensitive  = true
}

variable "client_id" {
  description = "The client ID generated for accessing the token."
  type        = string
  # TODO: Add once supported
  # sensitive  = true
}

variable "client_secret" {
  description = "The client secret generated for accessing the token."
  type        = string
  # TODO: Add once supported
  # sensitive  = true
}

variable "access_token" {
  description = "The access token used for authentication."
  type        = string
  # TODO: Add once supported
  # sensitive  = true
}
