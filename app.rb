require "sinatra"
require "sinatra/reloader"

require "http"
require "json"

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_KEY")}"

  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  @currencies = parsed_data.fetch("currencies")

  erb(:homepage)


end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency").gsub(':', '')

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_KEY"]}"
  
  raw_data = HTTP.get(api_url)

  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @currencies = parsed_data.fetch("currencies")

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  raw_data = HTTP.get(api_url)

  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @result = parsed_data.fetch("result")

  erb(:to_currency)
end
