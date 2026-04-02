library(plumber)
library(quantmod)
library(forecast)

#* Get stock data
#* @param symbol Stock symbol
#* @get /stock
function(symbol = "RELIANCE.NS") {
  data <- getSymbols(symbol, auto.assign = FALSE)
  close_prices <- Cl(data)

  return(list(
    prices = as.numeric(close_prices),
    dates = index(close_prices)
  ))
}

#* Predict future prices
#* @param symbol Stock symbol
#* @get /predict
function(symbol = "RELIANCE.NS") {
  data <- getSymbols(symbol, auto.assign = FALSE)
  close_prices <- Cl(data)

  model <- auto.arima(close_prices)
  forecast_data <- forecast(model, h=7)

  return(list(
    forecast = as.numeric(forecast_data$mean)
  ))
}