variable "azure_cred" {
  type        = string
  description = "Name for Azure credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "jira_cred" {
  type        = string
  description = "Name for Jira credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "project_key" {
  type        = string
  description = "Project key name in jira."
}
