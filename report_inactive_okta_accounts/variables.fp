variable "okta_domain" {
  type        = string
  description = "The URL of the Okta domain. Exmaple1: 'https://dev-50078045.okta.com'"
}

variable "api_token" {
  type        = string
  description = "The Okta personal access api_token to authenticate to the okta APIs, e.g., '00B630jSCGU4jV4o5Yh4KQMAdqizwE2OgVcS7N9UHb'. Please see https://developer.okta.com/docs/guides/create-an-api-api_token/main/#oauth-2-0-instead-of-api-api_tokens for more information."
}

// JIRA

variable "token" {
  type        = string
  description = "API access token"
  # TODO: Add once supported
  # sensitive  = true
}

variable "api_base_url" {
  type        = string
  description = "API base URL."
}

variable "project_key" {
  type        = string
  description = "The key identifying the project."
}

variable "user_email" {
  type        = string
  description = "Email-id of the Jira user."
}

variable "issue_type" {
  type        = string
  description = "Issue type."
}

variable "inactive_hours" {
  description = "Number of hours the user is inactive since current timestamp."
  type        = number
}