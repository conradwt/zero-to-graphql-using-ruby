##
## Base
##

FROM ruby:3.3.5-slim-bullseye as base

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
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_PORT 3000
ENV PORT ${RAILS_PORT}
ENV GEM_HOME="/usr/local/bundle"
ENV PATH ${GEM_HOME}/bin:${GEM_HOME}/gems/bin:${PATH}

ENV USER=darnoc
ENV UID=1000
ENV GID=1000

# creates an unprivileged user to be used exclusively to run the Rails app
RUN groupadd --gid ${GID} ${USER} \
  && useradd --uid ${UID} --gid ${GID} --shell /bin/bash --create-home ${USER}

#
# https://www.debian.org/distrib/packages#view
#

# install build and runtime dependencies
RUN apt-get update -qq -y && \
  apt-get install -qq --no-install-recommends -y \
  build-essential=12.9 \
  bzip2=1.0.8-4 \
  ca-certificates=20210119 \
  curl=7.74.0-1.3+deb11u11 \
  libfontconfig1=2.13.1-4.2 \
  libpq-dev \
  tini=0.19.0-1 && \
  rm -rf /var/lib/apt/lists/*

EXPOSE ${RAILS_PORT}

WORKDIR ${APP_PATH}

COPY --chown=darnoc:darnoc Gemfile* ./
RUN chown -R ${USER}:${USER} ${GEM_HOME}

RUN gem install bundler && \
  rm -rf ${GEM_HOME}/cache/*
RUN bundle config set without 'development test'
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

##
## Development
##

# note:  no source added, assumes bind mount

FROM base as dev

ENV RAILS_ENV=development

# RUN bundle config list
RUN bundle config --delete without
RUN bundle config --delete with
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

##
## Source
##

# note:  copy in source code for test and prod stages
#        we do this in its own stage to ensure the
#        layers we test are the exact hashed layers the cache
#        uses to build prod stage

FROM base as source

COPY --chown=darnoc:darnoc . .

##
## Test
##

# note: combine source code and dev stage deps

FROM source as test

ENV RAILS_ENV=test

RUN bundle exec robocop

CMD ["bundle", "exec", "rspec"]

##
## Production
##

FROM source as prod

HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "./entrypoint.sh"]

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-e", "production"]
