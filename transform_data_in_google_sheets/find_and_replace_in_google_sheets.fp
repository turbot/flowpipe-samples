
pipeline "find_and_replace_in_google_sheets" {
  title       = "Find and Replace Word"
  description = "Find and replace spefic word across all google spreadsheet."

  param "access_token" {
    type        = string
    description = "Access tokens are used for authentication in googleworkspace."
    default     = var.access_token
  }

  param "spreadsheet_id" {
    type        = string
    description = "The google spreadsheet ID."
  }

  param "find_text" {
    type        = string
    description = "The text to find."
  }

  param "replace_text" {
    type        = string
    description = "The text to replace."
  }

  step "pipeline" "find_and_replace_spreadsheet_data" {
    pipeline = googleworkspace.pipeline.find_replace_spreadsheet_data
    args = {
      access_token   = param.access_token
      find_text      = param.find_text
      replace_text   = param.replace_text
      spreadsheet_id = param.spreadsheet_id
    }
  }

  output "update_response" {
    description = "Details of the find and replace."
    value       = step.pipeline.find_and_replace_spreadsheet_data
  }
}
