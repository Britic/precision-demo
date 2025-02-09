require "sqlite3"

# Open database connection once and store it
DB_INSTANCE = DB.open "sqlite3:/app/src/prices.db"

def setup_database
  # Storing the price as text as SQL lite has no decimals and we don't want rounding errors
  DB_INSTANCE.exec "CREATE TABLE IF NOT EXISTS price_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      price TEXT NOT NULL,
      scraped_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )"
end
# Function to insert the price
def insert_price(product_id : Int32, price : Int32)
  DB_INSTANCE.exec "INSERT INTO price_history (product_id, price) VALUES (?, ?)", product_id, price.to_s
end

def fetch_prices
  results = [] of {Int64, String, String}
  DB_INSTANCE.query("SELECT product_id, price, scraped_at FROM price_history") do |rs|
    rs.each do
      product_id = rs.read(Int64)
      price = rs.read(String)
      scraped_at = rs.read(String)
      results << {product_id, price, scraped_at}
    end
  end
  results
end
