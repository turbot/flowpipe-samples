pipeline "text_example" {
  title = "Text Example"
  description = "This pipeline prompts the user for a name and then predicts the nationality based on the name."

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "text"
    prompt = "Type a name and I will predict the nationality based on it."
  }

  step "http" "name_prediction" {
      url    = "https://api.nationalize.io/?name=${step.input.my_input_step.value}"
      method = "get"
  }

  output "name_prediction" {
    value = step.http.name_prediction.response_body
  }
}
