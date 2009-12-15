# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pray2_session',
  :secret      => '41cce94f7a0f179f80e45a0592312c14ec1830df5a8d1573a9af33a80b18173c233d7afb30364228c092bf248a1e3e6134d6f91fb50368954960b035cbf9abd1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
