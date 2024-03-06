pipeline "select_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "select"
    prompt   = "Select a region:"

    option "us-east-1" {}
    option "us-east-2" {}
    option "us-west-1" {}
    option "us-west-2" {}
  }

  output "my_input_step" {
    value = step.input.my_input_step.value
  }
}
