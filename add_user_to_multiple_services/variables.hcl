variable "github_access_token" {
  type        = string
  description = "Github access token"
}

variable "github_organization" {
  type        = string
  description = "Github organization where the users will be created"
}

variable "okta_api_token" {
  type        = string
  description = "Okta API token"
}

variable "okta_domain" {
  type        = string
  description = "Okta domain"
}
