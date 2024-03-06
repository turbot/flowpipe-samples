pipeline "get_coin_price" {
  param "symbols" {
    type = list(string)
  }

  step "http" "coin_ticker" {
      url    = "https://api4.binance.com/api/v3/ticker/24hr"
      method = "get"
  }

  output "prices" {
    value = [for item in step.http.coin_ticker.response_body : {"symbol" = item.symbol, "lastPrice" = item.lastPrice} if contains(param.symbols, item.symbol)]
  }
}

