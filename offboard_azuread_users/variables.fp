// Azure
variable "subscription_id" {
  type        = string
  description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
}

variable "tenant_id" {
  type        = string
  description = "The Microsoft Entra ID tenant (directory) ID."
}

variable "client_secret" {
  type        = string
  description = "A client secret that was generated for the App Registration."
}

variable "client_id" {
  type        = string
  description = "The client (application) ID of an App Registration in the tenant."
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group. Examples: my_resource_group."
}

variable "project_key" {
  type        = string
  description = "Project key name in jira."
}
