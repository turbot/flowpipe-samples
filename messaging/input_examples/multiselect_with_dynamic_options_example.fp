pipeline "multiselect_with_dynamic_options_example" {
  title = "Multiselect with dynamic options example"
  description = "This pipeline demonstrates how to use a multiselect input step with dynamic options. The options are fetched from an API and then used in the input step. The pipeline fetches the current astronauts in space and then asks the user to select their favorite astronaut. The selected astronaut is then printed in the output step."

  param "notifier" {
    type = string
    default = "default"
  }

  step "http" "who_is_in_space" {
    url    = "http://api.open-notify.org/astros.json"
    method = "get"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "multiselect"
    prompt   = "Which astros do you like the most?"
    options  = [for astro in step.http.who_is_in_space.response_body.people : {"value" = astro.name}]
  }

  output "my_favorite_astros" {
    value = step.input.my_input_step.value
  }
}
