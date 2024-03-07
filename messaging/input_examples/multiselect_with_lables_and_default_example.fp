pipeline "multiselect_with_lables_and_default_example" {
  title = "Multiselect with labels and default example"
  description = "This pipeline demonstrates how to use a multiselect input step with custom labels and a default choice. It prompts the user to select one or more coin and then calls another pipeline to get the price of the selected coins."

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "multiselect"
    prompt   = "Get quote for:"

    option "btc_button" {
      label = "Bitcoin"
      value = "BTCUSDT"
    }
    option "eth_button" {
      label = "Ethereum"
      value = "ETHUSDT"
    }
    option "pepe_button" {
      label = "Pepe Coin"
      value = "PEPEUSDT"
    }
    option "doge_button" {
      label = "Doge Coin"
      value = "DOGEUSDT"
    }
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = step.input.my_input_step.value
    }
  }
}
