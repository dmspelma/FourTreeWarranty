# This Project Uses:
  - Ruby Version 3.1.1
  - Rails Version 6.1.7.2
  - Sidekiq - background processor
  - Wheneverize - crontab scheduler

# Run Project Locally:
  1. Clone project
  1. Navigate into repo
     * `bundle install`
     * `bundle exec rails db:migrate`
     * `bundle exec rails s`

# Run Project w/ Jobs Locally:
  1. Install redis-server:
     * `brew install redis`
  1. Then, start redis-server:
     * `redis-server`
  1. Clone project
  1. Navigate into repo:
     * `cp  .env.development.local.template .env.development.local`
     * Edit `.env.development.local` by supplying gmail address (Or other email by also editing `.env` file) and app password. App password can be found by adding 2FA to your account and get app password in settings.
     * `bundle install`
     * `bundle exec rails db:migrate`
     * `whenever --update-crontab`
     * `bundle exec sidekiq` -> This starts background processor
  1. In another terminal window, navigate into repo and run:
     * `bundle exec rails s`
