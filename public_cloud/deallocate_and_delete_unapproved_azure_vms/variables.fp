variable "azure_conn" {
  type        = connection.azure
  description = "Name for Azure connections to use. If not provided, the default connection will be used."
  default     = connection.azure.default
}

variable "zendesk_conn" {
  type        = connection.zendesk
  description = "Name for Zendesk connections to use. If not provided, the default connection will be used."
  default     = connection.zendesk.default
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
