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

// JIRA

variable "token" {
  type        = string
  description = "API access token"
}

variable "user_email" {
  type        = string
  description = "Email-id of the user."
}

variable "api_base_url" {
  type        = string
  description = "API base URL."
}

variable "project_key" {
  type        = string
  description = "The key identifying the project."
}
