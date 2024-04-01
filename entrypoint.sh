#!/bin/bash
# entrypoint.sh

echo "Waiting for the database to become available..."
/usr/local/bin/wait-for-it $DATABASE_HOSTNAME:5432 --timeout=30 --strict

echo "Running migrations..."
mix ecto.create
mix ecto.migrate

exec mix phx.server
