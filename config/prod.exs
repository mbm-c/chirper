use Mix.Config

config :chirper, ChirperWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  url: [scheme: "https", host: "chirperweb.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

database_url = System.get_env("DATABASE_URL")
if database_url do
  # Configure your database
  config :chriper, Chirper.Repo,
    url: System.get_env("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true
end

