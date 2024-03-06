pipeline "button_with_labels_and_values_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "button"
    prompt = "Get quote for BTC or ETH?"

    option "btc_button" {
      label = "Bitcoin"
      value = "BTCUSDT"
    }

    option "eth_button" {
      label = "Ethereum"
      value = "ETHUSDT"
    }
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = [step.input.my_input_step.value]
    }
  }
}
