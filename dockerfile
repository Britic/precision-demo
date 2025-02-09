# Use official Crystal image
FROM crystallang/crystal:latest

# Install SQLite3, and entr for live reloading
RUN apt-get update && apt-get install -y libsqlite3-dev entr

# Set working directory
WORKDIR /app

# Copy all project files
COPY ./ /app

# Install dependencies
RUN shards update
RUN shards install

# Ensure SQLite3 database file exists
RUN touch /app/prices.db && chmod 777 /app/prices.db

# Compile the application
RUN crystal build /app/src/server.cr -o /app/src/server --release
RUN crystal build /app/src/scraper.cr -o /app/src/scraper --release

# Ensure binaries are executable
RUN chmod +x /app/src/server /app/src/scraper

# Expose the web server port
EXPOSE 3000

# Default command: Watch for file changes & restart Crystal server
CMD ls /app/src/*.cr | entr -nr crystal run /app/src/server.cr