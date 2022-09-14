#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

#
# https://bundler.io/guides/bundler_docker_guide.html
#

# You will also need to unset BUNDLE_PATH and BUNDLE_BIN. Unsetting environment
# variables can be somewhat tricky in Docker, but the most common way is at the
# beginning of your ENTRYPOINT script:
unset BUNDLE_PATH
unset BUNDLE_BIN

# for development only:
#   if the gems are installed, skip bundle.
#   if not, install them.
bundle check || bundle install --jobs 20 --retry 5

# run any pending migrations
bin/rails db:migrate

# remove pre-existing puma or passenger server.pid
rm -f ${APP_PATH}/tmp/pids/server.pid

# run passed commands
bundle exec ${@}
