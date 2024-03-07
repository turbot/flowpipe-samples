pipeline "button_example" {
  title = "Button Example"
  description = "This pipeline demonstrates how to use the button input type. It prompts the user to select a coin and then calls another pipeline to get the price of the selected coin."

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "button"
    prompt = "Get quote for BTC or ETH?"

    option "BTCUSDT" {}
    option "ETHUSDT" {}
  }

  output "my_input_step" {
    value = step.input.my_input_step.value
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = [step.input.my_input_step.value]
    }
  }
}
