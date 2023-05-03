#!/bin/bash

# Start Redis. The `--daemonize yes` lets it run in backgroundd
redis-server --daemonize yes

# Start Sidekiq. The `&` lets it run in background
bundle exec sidekiq -C config/sidekiq.yml &

# Start the Rails server
bundle exec puma -C config/puma.rb
