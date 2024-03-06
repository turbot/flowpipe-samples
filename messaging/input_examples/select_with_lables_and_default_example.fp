pipeline "select_with_lables_and_default_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "select"
    prompt   = "Select a region:"

    option "us-east-1" {
      label     = "N. Virginia"
      selected  = true
    }
    option "us-east-2" {
      label     = "Ohio"
    }
    option "us-west-1" {
      label     = "N. California"
    }
    option "us-west-2" {
      label     = "Oregon"
    }
  }

  output "my_input_step" {
    value = step.input.my_input_step.value
  }
}
