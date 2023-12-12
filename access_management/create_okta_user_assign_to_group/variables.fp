variable "domain" {
  type        = string
  description = "The URL of the Okta domain. Exmaple: 'https://dev-50078045.okta.com'"
}

variable "api_token" {
  type        = string
  description = "The Okta personal access api_token to authenticate to the Okta APIs, e.g., '00B630jSCGU4jV4o5Yh4KQMAdqizwE2OgVcS7N9UHb'. Please see https://developer.okta.com/docs/guides/create-an-api-api_token/main/#oauth-2-0-instead-of-api-api_tokens for more information."
}
