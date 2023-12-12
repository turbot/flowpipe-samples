# Azure variables
variable "subscription_id" {
  type        = string
  description = "Azure Subscription Id. Examples: a1b2c3d4-wxyz-5678-bbbb-4d3c2b1a0."
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group. Examples: my_resource_group."
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

# Zendesk variables
variable "api_token" {
  type        = string
  description = "The Zendesk personal access token to authenticate to the Zendesk."
}

variable "user_email" {
  type        = string
  description = "The email address of the user which has been used to access the zendesk account."
}

variable "subdomain" {
  type        = string
  description = "The subdomain to which the Zendesk account is associated to."
}
