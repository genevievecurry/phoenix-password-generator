# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :pw_app, PwAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r8oVYJ3Lx80KSKgEUSKcltk6uaWy9emIyYmsgX7i4reSFxvMKW9z/txuJqpDiMol",
  render_errors: [view: PwAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PwApp.PubSub,
  live_view: [signing_salt: "pdoaJuet"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
