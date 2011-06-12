# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_iati_session',
  :secret      => '5da934871bf758710d43de0ce67c1c96f65f5b87fef60e2b921fc8393cb0b8e825ee90305828fb441f0f66bddb8792c895398ba72a246b1d0ddd737b3fe5fbe8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
