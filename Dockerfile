##
## Base
##

FROM ruby:3.0.2-alpine3.14 as base

# labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors=conradwt@gmail.com
LABEL org.opencontainers.image.created=$CREATED_DATE
LABEL org.opencontainers.image.revision=$SOURCE_COMMIT
LABEL org.opencontainers.image.title="Zero To GraphQL Using Ruby"
LABEL org.opencontainers.image.url=https://hub.docker.com/u/conradwt/zero-rails
LABEL org.opencontainers.image.source=https://github.com/conradwt/zero-to-graphql-using-rails
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
RUN \
  addgroup \
   -g "${GID}" \
   -S "${USER}" \
  && adduser \
   -s /bin/sh \
   -u "${UID}" \
   -G "${USER}" \
   -h "/home/${USER}" \
   -D "${USER}" \
  && su "${USER}"

# copy entrypoint scripts and grant execution permissions
# COPY ./dev-docker-entrypoint.sh /usr/local/bin/dev-entrypoint.sh
# COPY ./test-docker-entrypoint.sh /usr/local/bin/test-entrypoint.sh
# RUN chmod +x /usr/local/bin/dev-entrypoint.sh && chmod +x /usr/local/bin/test-entrypoint.sh

#
# https://pkgs.alpinelinux.org/packages?name=&branch=v3.13
#

# install build and runtime dependencies
RUN apk -U add --no-cache \
  build-base=0.5-r2 \
  bzip2=1.0.8-r1 \
  ca-certificates=20191127-r5 \
  curl=7.78.0-r0 \
  fontconfig=2.13.1-r4 \
  postgresql-dev=13.4-r0 \
  tini=0.19.0-r0 \
  tzdata=2021a-r0 && \
  rm -rf /var/cache/apk/* && \
  mkdir -p $APP_PATH

ENV RAILS_ENV=production

EXPOSE ${RAILS_PORT}
ENV PORT ${RAILS_PORT}

WORKDIR ${APP_PATH}

COPY Gemfile* ./

RUN gem install bundler && \
  rm -rf ${GEM_HOME}/cache/*
RUN bundle config set without 'development test'
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
