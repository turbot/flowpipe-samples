pipeline "button_with_labels_and_values_example" {
  title = "Button with Labels and Values Example"
  description = "This pipeline demonstrates how to use a button input step by customizing the labels and values of the buttons. It prompts the user to select a coin and then calls another pipeline to get the price of the selected coin."

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
