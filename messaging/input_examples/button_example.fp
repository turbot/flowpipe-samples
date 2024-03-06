pipeline "button_example" {

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
