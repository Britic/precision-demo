require "http/client"
require "myhtml"
require "./database"
require "big"

# Function to scrape the price of a specified product ID
def scrape_price

  product_id : String = "0123456789"

  # Base URL
  url = "https://bush-daisy-tellurium.glitch.me/"  # Replace with the actual URL

  # Adding the Referer here as the destination seemed to need it remporarily
  response = HTTP::Client.get(url, headers: HTTP::Headers{"Referer" => url})

  # Fetch HTML content
  html = response.body

  # Would normally add some error handling in here

  # Initialize the parser and parse the response
  myhtml = Myhtml::Parser.new(html)

  # Directly select the div with the `data-asin` attribute
  product_div = myhtml.nodes(:div).find { |node| node.attribute_by("data-asin") == product_id }  
  
  # Let's see if we found a matchign element
  if product_div
    # We did, let's log that
    puts "Found product div with ASIN " + product_id

    # Search for the nested div with class 'price'
    price_div = product_div.scope.nodes(:div).find { |n| n.attribute_by("class") == "price" }

    # If we find the price div, parse the content
    if price_div
      price_text = price_div.inner_text.strip.gsub(/[^\d.]/, "") # Regex to parse the numeric value
      
      # Ensure we handle prices without decimals
      if price_text.size > 2
        formatted_price = price_text.insert(price_text.size - 2, ".")
      else
        formatted_price = price_text
      end
      
      # convert to cents
      price_text = (BigDecimal.new(price_text) * 100).to_i
      

      # Update the product with the new price
      insert_price(product_id.to_i, price_text)
      puts "Scraped and saved price: #{price_text}"
    else
      puts "Price div not found inside product div"
    end
  else
    puts "Product div with ASIN " + product_id + " not found"
  end
end