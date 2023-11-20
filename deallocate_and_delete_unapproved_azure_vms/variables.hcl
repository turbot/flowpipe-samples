# Azure variables
variable "subscription_id" {
  type        = string
  description = "Azure Subscription Id. Examples: a1b2c3d4-wxyz-5678-bbbb-4d3c2b1a0."
  # TODO: Add once supported
  #sensitive  = true
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group. Examples: my_resource_group."
  # TODO: Add once supported
  #sensitive  = true
}

variable "tenant_id" {
  type        = string
  description = "The Microsoft Entra ID tenant (directory) ID."
  # TODO: Add once supported
  #sensitive  = true
}

variable "client_secret" {
  type        = string
  description = "A client secret that was generated for the App Registration."
  # TODO: Add once supported
  #sensitive  = true
}

variable "client_id" {
  type        = string
  description = "The client (application) ID of an App Registration in the tenant."
  # TODO: Add once supported
  #sensitive  = true
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
