#!/bin/bash
# entrypoint.sh

# Download and install wait-for-it if not already present
if [ ! -f /usr/local/bin/wait-for-it ]; then
    apt-get update && apt-get install -y wget && \
    wget -q -O /usr/local/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it
fi

# Use the DATABASE_HOSTNAME environment variable to wait for the database
echo "Waiting for the database to become available..."
/usr/local/bin/wait-for-it $DATABASE_HOSTNAME:5432 --timeout=30 --strict

# Run migrations
echo "Running migrations..."
mix ecto.create
mix ecto.migrate

# Start the Phoenix server
exec mix phx.server
