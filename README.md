# Price Tracking Project

## Architecture Decisions

As someone new to the crystal language, and this being a technical demo, most of the focus is on functionality.

That said, there were some considerations applied in the application to point out.

- Database design
    - There is only one table, but it allows for the identification of the product_id, as this would no doubt track the history of many products
    - The price column is text
        - SqlLite can't store decimals, and we don't want floats for currency, so I used text here to store the value in cents
        - An integer would also work here, but I didn't have time to reconvert and wanted to explain this choice
        - I did not include the database in the repo. The application will build a fresh instance


- Function design
    - The `scrape_price` function defines the product_id but this could easily be a parameter, making it easy to re-use for multiple product IDS
    - An examination of the page source made it clear there was an `asin` value to identify the product. This was used in the HTML parsing as this value will remain static
    - The HTML parser looks only for the relevant div based on the `data-asin` value. This limits node traversal.
    - The scrape now functionality utilizes the same function as the fetched job

- System Design
    - I'm not familiar enough with crystal to know how (or if it's possible!) to build out more abstractions
    - Functionality was built to meet the deliverables
    - Added some additional functionality outside of scope
        - Scrape runs every minute, page refresh happens at 5 seconds past the minute so there willbe new data
        - Countdown timer to next scrape
        - Dynamically updating chart

- Suggested Improvements given time/resources
    - Gracefully handle errors
    - Adapt to handle mutiple products via array
        - Handle multiple products on the same page to prevent unnecessary duplicate requests
    - Charts
        - Update the chart ticks to accurately represent time (space out accordingly)
    - Tests
        - Unit
        - Integration
    - Logging/Alerts
        - Notify when a product price can't be found
        - Out of expected range exceptions
    - Caching
        - Reduce database I/O

---

## Deployment
This project contains a docker container that will be able to run the application on port 3000.

### Deployment Instructions
1. Clone the repo
2. `docker compose up` to build the image and start the container
3. Navigate to `http://127.0.0.1:3000/`

The application should now be deployed locally and accesible

### Container Information
See the dockerfile for more information, but the build
- Pulls in the latest version of crystal
- Updates, and then installs
    - `libsqlite3` for database functionality
    - `entr` for live reloading to avoid rebuilds/compilations after chnages made during development
        - Not something needed outside of a development environment!
- Copies relevant files
- Starts the server

--- 

## Resources

Resources Used to help during development

- Crystal Language Docs
    - https://crystal-lang.org/api/1.15.1/
    - Used for implementation specifics
- MyHtml Library docs
    - https://github.com/kostya/myhtml
    - Used for implementation specifics
- Chat GPT
    - Helped with a broad overview of some language contsructs
    - Assisted with dockerfile creation
    - I don't trust code from Chat GPT, but it's a useful starting point to check the documentation
