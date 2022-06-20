##
## Base
##

FROM ruby:3.1.2-slim-bullseye as base

# labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors=conradwt@gmail.com
LABEL org.opencontainers.image.created=$CREATED_DATE
LABEL org.opencontainers.image.revision=$SOURCE_COMMIT
LABEL org.opencontainers.image.title="Zero To GraphQL Using Ruby"
LABEL org.opencontainers.image.url=https://hub.docker.com/u/conradwt/zero-to-graphql-using-ruby
LABEL org.opencontainers.image.source=https://github.com/conradwt/zero-to-graphql-using-ruby
LABEL org.opencontainers.image.licenses=MIT
LABEL com.conradtaylor.ruby_version=$RUBY_VERSION

# set this with shell variables at build-time.
# If they aren't set, then not-set will be default.
ARG CREATED_DATE=not-set
ARG SOURCE_COMMIT=not-set

# environment variables
ENV APP_PATH /home/darnoc/app
ENV BUNDLE_PATH /usr/local/bundle/gems
ENV TMP_PATH /tmp/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_PORT 3000

ENV USER=darnoc
ENV UID=1000
ENV GID=1000

# creates an unprivileged user to be used exclusively to run the Rails app
RUN groupadd --gid 1000 darnoc \
  && useradd --uid 1000 --gid darnoc --shell /bin/bash --create-home darnoc

# copy entrypoint scripts and grant execution permissions
# COPY ./dev-docker-entrypoint.sh /usr/local/bin/dev-entrypoint.sh
# COPY ./test-docker-entrypoint.sh /usr/local/bin/test-entrypoint.sh
# RUN chmod +x /usr/local/bin/dev-entrypoint.sh && chmod +x /usr/local/bin/test-entrypoint.sh

#
# https://www.debian.org/distrib/packages#view
#

# install build and runtime dependencies
RUN apt-get update -qq -y && \
  apt-get install -qq --no-install-recommends -y \
  build-essential=12.9 \
  bzip2=1.0.8-4 \
  ca-certificates=20210119 \
  curl=7.74.0-1.3+deb11u1 \
  libfontconfig1=2.13.1-4.2 \
  libpq-dev && \
  rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production

EXPOSE ${RAILS_PORT}
ENV PORT ${RAILS_PORT}

WORKDIR ${APP_PATH}

COPY Gemfile* ./

RUN gem install bundler && \
  rm -rf ${GEM_HOME}/cache/*
RUN bundle config set without 'development test'
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . .

RUN chmod +x ./entrypoint.sh

RUN chown -R ${USER}:${USER} ${APP_PATH}

ENTRYPOINT ["/sbin/tini", "--", "./entrypoint.sh"]

##
## Development
##

FROM base as dev

ENV RAILS_ENV=development

# RUN bundle config list
RUN bundle config --delete without
RUN bundle config --delete with
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

USER ${USER}:${USER}

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

##
## Test
##

FROM dev as test

USER ${USER}:${USER}

CMD ["bundle", "exec", "rspec"]

##
## Pre-Production
##

FROM test as pre-prod

USER root

RUN rm -rf ./spec

##
## Production
##

FROM base as prod

COPY --from=pre-prod ${APP_PATH} ${APP_PATH}

HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1

USER ${USER}:${USER}

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-e", "production"]
