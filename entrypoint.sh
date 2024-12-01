#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -rf /app/tmp/pids/server.pid

bundle exec rake db:drop
bundle exec rake db:create

# migrate
bundle exec rake db:migrate


# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
