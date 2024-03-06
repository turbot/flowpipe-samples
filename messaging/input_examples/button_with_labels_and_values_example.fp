pipeline "button_with_labels_and_values_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "button"
    prompt = "Do you want to approve?"

    option "approve_button" {
      label = "Approve"
      value = "approve_button_pressed"
    }

    option "deny_button" {
      label = "Deny"
      value = "deny_button_pressed"
    }
  }

  output "my_input_step" {
    value = step.input.my_input_step.value
  }
}
