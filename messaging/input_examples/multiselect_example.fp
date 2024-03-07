pipeline "multiselect_example" {
  title = "Multiselect Example"
  description = "This pipeline demonstrates how to use the multiselect input type. It prompts the user to select one or more coin and then calls another pipeline to get the price of the selected coins."

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "multiselect"
    prompt   = "Get quote for:"

    option "BTCUSDT" {}
    option "ETHUSDT" {}
    option "PEPEUSDT" {}
    option "DOGEUSDT" {}
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = step.input.my_input_step.value
    }
  }
}
