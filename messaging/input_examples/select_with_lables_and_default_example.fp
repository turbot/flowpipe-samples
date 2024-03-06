pipeline "select_with_lables_and_default_example" {

  param "notifier" {
    type = string
    default = "default"
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type     = "select"
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
      symbols = [step.input.my_input_step.value]
    }
  }
}
