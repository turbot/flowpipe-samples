variable "abuseipdb_api_key" {
  type        = string
  description = "API key to authenticate requests with AbuseIPDB."
  // TODO: Add once supported
  // sensitive  = true
}

variable "ip2location_api_key" {
  type        = string
  description = "API key to authenticate requests with IP2Location."
  // TODO: Add once supported
  // sensitive  = true
}

variable "virustotal_api_key" {
  type        = string
  description = "API key to authenticate requests with VirusTotal."
  // TODO: Add once supported
  // sensitive  = true
}
