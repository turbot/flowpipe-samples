# Common descriptions
locals {
  client_id_param_description       = "The client (application) ID of an App Registration in the tenant."
  client_secret_param_description   = "A client secret that was generated for the App Registration."
  resource_group_param_description  = "Azure Resource Group. Examples: my-rg, my-rg-123."
  subscription_id_param_description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
  tenant_id_param_description       = "The Microsoft Entra ID tenant (directory) ID."
  api_token_param_description       = "The Zendesk personal access token to authenticate to the Zendesk."
  subdomain_param_description       = "The subdomain to which the Zendesk account is associated to."
  user_email_param_description      = "Email address of agent user who has permission to access the API."
}


# Convenience variables
locals {
  # Approved list of Virtual Machines. Must be of type list(number)
  approved_vm_names = ["fpdemo", "demo"]
}
