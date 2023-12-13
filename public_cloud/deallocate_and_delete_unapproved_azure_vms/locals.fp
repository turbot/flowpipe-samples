# Common descriptions
locals {
  resource_group_param_description  = "Azure Resource Group. Examples: my-rg, my-rg-123."
  subscription_id_param_description = "Azure Subscription Id. Examples: d46d7416-f95f-4771-bbb5-529d4c766."
}


# Convenience variables
locals {
  # Approved list of Virtual Machines. Must be of type list(number)
  approved_vm_names = ["fpdemo", "demo"]
}
