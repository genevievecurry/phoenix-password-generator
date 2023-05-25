import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    """

config :pw_app, PwAppWeb.Endpoint,
  # Possibly not needed, but doesn't hurt
  http: [
    port: String.to_integer(System.get_env("PORT") || "8080")
  ],
  url: [host: "phoenix-password-generator.fly.dev", port: 443],
  secret_key_base: secret_key_base,
  server: true
