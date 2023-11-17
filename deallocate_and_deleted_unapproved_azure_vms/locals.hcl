# Common descriptions
locals {
  tenant_id_param_description       = "The Microsoft Entra ID tenant (directory) ID."
  client_secret_param_description   = "A client secret that was generated for the App Registration."
  client_id_param_description       = "The client (application) ID of an App Registration in the tenant."
  subscription_id_param_description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
}


# Convenience variables
locals {
  # Approved list of Virtual Machines. Must be of type list(number)
  approved_vm_names = ["fpdemo", "demo"]
}
