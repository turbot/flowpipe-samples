variable "aws_region" {
  type        = string
  description = "The name of the Region."
}

variable "aws_access_key_id" {
  type        = string
  description = "The ID for this access key."
}

variable "aws_secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
}

variable "github_repository_full_name" {
  type        = string
  description = "The full name of the GitHub repository. Examples: turbot/steampipe, turbot/flowpipe."
}

variable "github_token" {
  type        = string
  description = "The GitHub personal access token to authenticate to the GitHub APIs, e.g., `github_pat_a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16q17r18s19t20u21v22w23x24y25z26`. Please see https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens for more information."
}
