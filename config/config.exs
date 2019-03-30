# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chirper,
  ecto_repos: [Chirper.Repo]

# Configures the endpoint
config :chirper, ChirperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OZ693zmzdMmD1ud2CiPWjvL6djAPOeoUTTaEJ1qdwAZZv1rDSD8P34uNy37+5qq2",
  render_errors: [view: ChirperWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chirper.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
