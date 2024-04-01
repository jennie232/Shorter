import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :shorter, Shorter.Repo,
  username: System.get_env("DATABASE_USERNAME"),
  hostname: System.get_env("DATABASE_HOSTNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_NAME"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shorter, ShorterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "BWTEdJjYPhNtQt/JDBkuxIzMJOzA7ozQCwgfRgEluSMXROb4jrgT/zJG8p+j4/dc",
  server: false

# In test we don't send emails.
config :shorter, Shorter.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

config :shorter, base_url: "http://localhost:4000"

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
