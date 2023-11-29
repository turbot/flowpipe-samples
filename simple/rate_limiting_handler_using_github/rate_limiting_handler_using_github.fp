pipeline "rate_limiting_handler_using_github" {
  title       = "Rate Limiting Handler Using Github"
  description = "Handle throttling error with retries for Github List issues API."

  param "access_token" {
    type        = string
    description = local.access_token_param_description
    default     = var.access_token
  }

  param "repository_owner" {
    type        = string
    description = local.repository_owner_param_description
    default     = local.repository_owner
  }

  param "repository_name" {
    type        = string
    description = local.repository_name_param_description
    default     = local.repository_name
  }


  param "issue_state" {
    type        = string
    description = "The possible states of an issue. Allowed values are OPEN and CLOSED. Defaults to OPEN."
    default     = "open"
  }

  param "issues_limit" {
    type    = number
    default = 10
  }

  step "http" "list_issues" {
    method = "get"
    url    = "https://api.github.com/repos/${param.repository_owner}/${param.repository_name}/issues?state=${param.issue_state}&per_page=${param.issues_limit}"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.access_token}"
    }

    retry {
      if           = result.status_code.status_code == 404
      max_attempts = 10
    }
  }

  output "issues" {
    description = "List of Issues."
    value       = step.http.list_issues
  }

}