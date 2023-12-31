#!/bin/bash

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

for n in {1..6}; do
  (bundle exec rails db:migrate ||
  echo "Database setup/migration failed. Retry in 10s...") && break
  sleep 10
done

if [[ $RAILS_ENV = "development" ]]; then
  bundle exec rails s -b 0.0.0.0
  sleep 20
else
  bundle exec rails s -b 0.0.0.0 -e "$RAILS_ENV" -p 3000
fi
