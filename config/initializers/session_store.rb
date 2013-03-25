# Be sure to restart your server when you modify this file.

if Rails.env.development?
  cookie_domain = 'lvh.me'
elsif Rails.env.production?
  cookie_domain = 'subdomainbox.com'
end

SubdomainboxDemo::Application.config.session_store :cookie_store, key: '_subdomainbox_demo_session', :domain => cookie_domain

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# SubdomainboxDemo::Application.config.session_store :active_record_store
