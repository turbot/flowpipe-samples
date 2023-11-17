
trigger "schedule" "deallocate_and_deleted_unapproved_azure_vms" {
  description = "A daily cron job at 9 AM UTC that checks for Azure Unapproved VMs, deallocates and deletes them."
  schedule    = "0 9 * * *"
  pipeline    = pipeline.deallocate_and_deleted_unapproved_azure_vms
}

pipeline "deallocate_and_deleted_unapproved_azure_vms" {

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type = string
    # description = local.tenant_id_param_description
    default = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tags_query" {
    type        = string
    description = "A JMESPath query to use in filtering the response data."
    default     = "[?tags.environment=='development' || tags.environment=='dev'].name"
  }

  # List Azure VMs with the given tags as per the query param.
  step "pipeline" "list_azure_vms" {
    pipeline = azure.pipeline.list_compute_virtual_machines
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      query           = param.tags_query
    }
  }

  # For list of VMs with required Tags, get the instance status of each VM.
  step "pipeline" "get_compute_virtual_machine_status" {
    for_each = { for name in step.pipeline.list_azure_vms.output.stdout : name => name }
    pipeline = azure.pipeline.get_compute_virtual_machine_status
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.value
      query           = "instanceView.statuses[1]"
    }
  }

  # For list of VMs with required Tags, NOT added to approved list and in running state, then deallocate the VMs.
  step "pipeline" "deallocate_instances" {
    for_each = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_status : vm_name => vm_status.output.stdout
      if vm_status.output.stdout.displayStatus == "VM running" && !contains(local.approved_vm_names, vm_name)
    }
    pipeline = azure.pipeline.deallocate_compute_virtual_machine
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.key
    }
  }

  # For list of VMs with required Tags, NOT added to approved list and in deallocated or stopped state, then delete the VMs.
  step "pipeline" "delete_instances" {
    for_each = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_status : vm_name => vm_status.output.stdout
      if(vm_status.output.stdout.displayStatus == "VM deallocated" || vm_status.output.stdout.displayStatus == "VM stopped") && !contains(local.approved_vm_names, vm_name)
    }
    pipeline = azure.pipeline.delete_compute_virtual_machine
    args = {
      tenant_id       = param.tenant_id
      client_secret   = param.client_secret
      client_id       = param.client_id
      subscription_id = param.subscription_id
      resource_group  = param.resource_group
      vm_name         = each.key
    }
  }

  output "vms_with_tag" {
    value = step.pipeline.list_azure_vms.output.stdout
  }

  output "vm_statuses" {
    value = { for vm_name, vm_status in step.pipeline.get_compute_virtual_machine_status : vm_name => vm_status.output.stdout }
  }

  output "deallocated_vms" {
    value = { for vm_name, vm_deallocation in step.pipeline.deallocate_instances : vm_name => "${vm_name} deallocated" if vm_deallocation.output.stdout == "" }
  }

  output "deleted_vms" {
    value = { for vm_name, vm_deletion in step.pipeline.delete_instances : vm_name => "${vm_name} deleted" if vm_deletion.output.stdout == "" }
  }

}
