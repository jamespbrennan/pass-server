# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
PassServer::Application.config.secret_key_base = '60f3a64096a71241be9aeecac9476723407d99abee77cec2b25bbdc81b8fedf0fb2b4b0311ee99a73fd158dfe48c1f24c9605d1b9f49007022bb09ca6b8cbb7b'
