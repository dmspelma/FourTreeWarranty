# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
# require 'sidekiq/web'

run Rails.application
Rails.application.load_server

# Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
# Specify your desired username and password here
# user == 'admin' && password == 'password' # Disabled for production currently
# end
