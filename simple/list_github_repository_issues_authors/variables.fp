variable "github_access_token" {
  type        = string
  description = "The GitHub personal access token to authenticate to the GitHub APIs."
}

variable "github_repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe"
}
