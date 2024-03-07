pipeline "select_example" {
  title = "Select Example"
  description = "This pipeline demonstrates how to use the select input type. It prompts the user to select a coin and then calls another pipeline to get the price of the selected coin."

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "select"
    prompt   = "Get quote for:"

    option "BTCUSDT" {}
    option "ETHUSDT" {}
    option "PEPEUSDT" {}
    option "DOGEUSDT" {}
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = [step.input.my_input_step.value]
    }
  }
}
