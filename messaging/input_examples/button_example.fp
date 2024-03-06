pipeline "button_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "button"
    prompt = "Do you want to approve?"

    option "Approve" {}
    option "Deny" {}
  }

  output "my_input_step" {
    value = step.input.my_input_step.value
  }
}
