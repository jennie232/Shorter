# Use the Elixir 1.16.2 base image
FROM elixir:1.16.2

# Set the working directory inside the container
WORKDIR /shorter

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools

# Copy your application code and the entrypoint script into the container
COPY . .
COPY entrypoint.sh /entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Install Hex and Rebar, and fetch the project dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Compile the application
RUN mix compile

# Set the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# The command to run when the container starts
CMD ["mix", "phx.server"]
