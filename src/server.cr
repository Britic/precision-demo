require "kemal"
require "./scraper"
require "./database"

setup_database

# Run the scraper every 15s to populate data
spawn do
  loop do
    puts "Running automated scraper"
    scrape_price
    sleep 15.seconds  # Seconds
  end
end


# Route for index 
get "/" do |env|
  env.response.content_type = "text/html"
  File.read("public/index.html")
end

# Route for fetching prices
get "/prices" do
  # Fetch the prices
  prices = fetch_prices
  # Return as JSON
  prices.to_json
end

# API to trigger a new scrape
post "/scrape" do
  scrape_price
end

# Run the server
Kemal.run