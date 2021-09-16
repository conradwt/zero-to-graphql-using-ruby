#!/bin/sh

set -e

# remove a potentially pre-existing server.pid for Rails.
rm -f ${APP_PATH}/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
