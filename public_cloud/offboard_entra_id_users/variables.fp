variable "azure_conn" {
  type        = connection.azure
  description = "Name of Azure connection to use. If not provided, the default Azure connection will be used."
  default     = connection.azure.default
}

variable "jira_conn" {
  type        = connection.jira
  description = "Name of Jira connection to use. If not provided, the default Jira connection will be used."
  default     = connection.jira.default
}

variable "project_key" {
  type        = string
  description = "Project key name in jira."
}
