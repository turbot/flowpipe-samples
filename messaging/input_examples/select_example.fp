pipeline "select_example" {

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
