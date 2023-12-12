pipeline "run_search_in_splunk" {
  title       = "Run Search in Splunk"
  description = "Runs the provided search in Splunk, waits for the search to complete, and returns the results."

  tags = {
    type = "featured"
  }

  param "splunk_auth_token" {
    type        = string
    default     = var.splunk_auth_token
    description = "Auth token to authenticate requests with Splunk."
  }

  param "splunk_server" {
    type        = string
    default     = var.splunk_server
    description = "The Splunk server."
  }

  param "search_query" {
    type        = string
    description = "The query to be searched."
  }

  param "insecure" {
    type        = bool
    description = "Disable TLS verification."
  }

  # Initiate search request
  step "http" "initiate_search" {
    method   = "post"
    insecure = param.insecure
    url      = "https://${param.splunk_server}:8089/services/search/v2/jobs/?output_mode=json"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Splunk ${param.splunk_auth_token}"
    }

    request_body = jsonencode({
      search = param.search_query
    })
  }

  # Check search status
  step "http" "search_status" {
    depends_on = [step.http.initiate_search]
    method     = "post"
    insecure   = param.insecure
    url        = "https://${param.splunk_server}:8089/services/search/v2/jobs/${step.http.initiate_search.response_body.entry[0].content.sid}/?output_mode=json"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Splunk ${param.splunk_auth_token}"
    }

    loop {
      until = result.response_body.entry[0].content.dispatchState == "DONE" || loop.index < 20
      url   = "https://${param.splunk_server}:8089/services/search/v2/jobs/${step.http.initiate_search.response_body.entry[0].content.sid}/?output_mode=json"
    }
  }

  # Fetch search result
  step "http" "search_result" {
    depends_on = [step.http.search_status]
    method     = "post"
    insecure   = param.insecure
    url        = "https://${param.splunk_server}:8089/services/search/v2/jobs/${step.http.initiate_search.response_body.entry[0].content.sid}/results/?output_mode=json"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Splunk ${param.splunk_auth_token}"
    }
  }

  output "search_result" {
    value = step.http.search_result.response_body
  }
}