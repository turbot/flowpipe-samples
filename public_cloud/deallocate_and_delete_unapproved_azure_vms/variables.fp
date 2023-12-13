variable "azure_cred" {
  type        = string
  description = "Name for Azure credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "zendesk_cred" {
  type        = string
  description = "Name for Zendesk credentials to use. If not provided, the default credentials will be used."
  default     = "default"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription Id. Examples: a1b2c3d4-wxyz-5678-bbbb-4d3c2b1a0."
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group. Examples: my_resource_group."
}

variable "tags_query" {
  type        = string
  description = "A JMESPath query to use in filtering the response data."
  default     = "[?tags.environment=='development' || tags.environment=='dev'].name"
}
