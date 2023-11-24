variable "okta_domain" {
  type        = string
  description = "The URL of the Okta domain. Exmaple1: 'https://dev-50078045.okta.com'"
}

variable "api_token" {
  type        = string
  description = "The Okta personal access api_token to authenticate to the okta APIs, e.g., '00B630jSCGU4jV4o5Yh4KQMAdqizwE2OgVcS7N9UHb'. Please see https://developer.okta.com/docs/guides/create-an-api-api_token/main/#oauth-2-0-instead-of-api-api_tokens for more information."
}

variable "group_id" {
  description = "The ID of the group."
  type        = string
}

variable "first_name" {
  description = "Given name of the user."
  type        = string
}

variable "last_name" {
  description = "The family name of the user."
  type        = string
}

variable "email" {
  description = "The primary email address of the user."
  type        = string
}

variable "login" {
  description = "The unique identifier for the user."
  type        = string
}

variable "password" {
  description = "Specifies the password for a user."
  type        = string
}  