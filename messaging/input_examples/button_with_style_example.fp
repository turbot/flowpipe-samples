pipeline "button_with_style_example" {
  title = "Button Example with Style"
  description = "This pipeline demonstrates how to use the button input type with different styles. It show the user the current price of Bitcoin and asks them what they want to do with it."

  param "notifier" {
    type = string
    default = "default"
  }

  step "pipeline" "get_coin_price" {
    pipeline = pipeline.get_coin_price
    args = {
      symbols = ["BTCUSDT"]
    }
  }

  step "input" "my_input_step" {
    notifier = notifier[param.notifier]
    type   = "button"
    prompt = "Bitcoin is currently trading at $ ${step.pipeline.get_coin_price.output.prices[0].lastPrice}. What do you want to do?"

    option "buy" {
      style = "ok"
    }
    option "sell" {
      style = "alert"
    }
    option "hold" {
      style = "info"
    }
  }

  output "my_input_step" {
    value = "I'm gonna ${step.input.my_input_step.value} it."
  }
}
