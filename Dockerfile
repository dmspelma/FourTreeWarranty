FROM ruby:3.1.1

# Set the base directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy dependencies into the container
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test

RUN apt-get update
RUN apt-get install -y nodejs
# RUN apt-get install -y apt-transport-https ca-certificates # This is for caprover https certificates
RUN apt-get install -y npm
RUN npm install -g yarn
RUN redis-server

# Set the Rails environment to production
ENV RAILS_ENV production
ENV RACK_ENV production

# Copy the main application into the container
COPY . ./

# Copy the startup script
COPY start.sh .

# Set execute permission on the script
RUN chmod +x start.sh

# Precompile the Rails assets
RUN bundle exec rake assets:precompile

# Start the server with the script
CMD ./start.sh
