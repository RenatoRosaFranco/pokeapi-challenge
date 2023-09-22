FROM ruby:3.2.0

LABEL maintainer="devops@pokeapi.io"

ENV API_HOME=/app
RUN mkdir -p $API_HOME

# Required Variables
ARG PORT_ARG=3000
ENV PORT=$PORT_ARG

ARG RAILS_ENV_ARG=development
ENV RAILS_ENV=$RAILS_ENV_ARG

# Dev dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs sqlite3 libsqlite3-dev

# Change TimeZone
ENV TZ=America/Sao_Paulo

# Copy application into container
COPY . $API_HOME/
WORKDIR $API_HOME

COPY Gemfile Gemfile.lock ./

# Install Bundler
ARG EXCLUDE_GEMS="test"
RUN gem install bundler --no-document
RUN bundle config set specific_platform true
RUN bundle config set without $EXCLUDE_GEMS
RUN bundle install

# Use the following lines for Rails Apps
RUN chmod +x ./server.sh

# API Runner
EXPOSE $PORT

# Start rails server
CMD ["bash", "./server.sh"]
