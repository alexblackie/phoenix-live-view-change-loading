# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :reproducer,
  ecto_repos: [Reproducer.Repo]

# Configures the endpoint
config :reproducer, ReproducerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bEmcFMRkfB9vMVKpNqYzIHUIRbf2ob7ZnpBGTWTGQ+AgnENie6P7KNqITZXHzoHu",
  render_errors: [view: ReproducerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Reproducer.PubSub,
  live_view: [signing_salt: "zo+96N+N"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
