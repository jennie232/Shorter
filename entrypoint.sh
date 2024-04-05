#!/bin/bash
# entrypoint.sh

echo "Waiting for the database to become available..."
/usr/local/bin/wait-for-it $DATABASE_HOSTNAME:5432 --timeout=30 --strict

# Test mode
if [ "$MIX_ENV" = "test" ]; then
    echo "Running in test mode..."

    echo "Fetching dependencies..."
    mix deps.get
    
    echo "Creating and migrating the test database..."
    mix ecto.create
    mix ecto.migrate
    
    echo "Running tests..."
    mix test

# Dev mode
else
    echo "Running in development mode..."
    
    echo "Running migrations..."
    mix ecto.create
    mix ecto.migrate

    echo "Starting Phoenix server..."
    exec mix phx.server
fi
