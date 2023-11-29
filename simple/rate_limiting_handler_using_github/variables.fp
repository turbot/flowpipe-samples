variable "access_token" {
  type        = string
  description = "The GitHub personal access token to authenticate to the GitHub APIs."
}

variable "repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe"
}