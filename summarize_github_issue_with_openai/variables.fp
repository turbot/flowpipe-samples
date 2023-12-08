variable "openapi_api_key" {
  type        = string
  description = "The OpenAI API key to authenticate to the OpenAI APIs, e.g., `sk-a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16q17r18s19`. Please see https://platform.openai.com/account/api-keys for more information."
}

variable "repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe"
}