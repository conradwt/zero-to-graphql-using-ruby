## Base

FROM ruby:3.0.0-alpine3.13 as base

# RUN addgroup --gid 1000 nobody \
#   && adduser --uid 1000 --ingroup nobody --shell /bin/bash --home nobody

# set this with shell variables at build-time.
# If they aren't set, then not-set will be default.
ARG CREATED_DATE=not-set
ARG SOURCE_COMMIT=not-set

# labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors=conradwt@gmail.com
LABEL org.opencontainers.image.created=$CREATED_DATE
LABEL org.opencontainers.image.revision=$SOURCE_COMMIT
LABEL org.opencontainers.image.title="Zero To GraphQL Using Rails"
LABEL org.opencontainers.image.url=https://hub.docker.com/u/conradwt/zero-rails
LABEL org.opencontainers.image.source=https://github.com/conradwt/zero-to-graphql-using-rails
LABEL org.opencontainers.image.licenses=MIT
LABEL com.conradtaylor.ruby_version=$RUBY_VERSION

# install runtime dependencies
RUN apk add --no-cache \
  bzip2=1.0.8-r1 \
  ca-certificates=20191127-r5 \
  curl=7.74.0-r0 \
  fontconfig=2.13.1-r3 \
  tini=0.19.0-r0

# install build dependencies
RUN apk add --no-cache --virtual build-dependencies \
  build-base=0.5-r2 \
  postgresql-dev=13.1-r2

ENV RAILS_ENV=production

EXPOSE 3000
ENV PORT 3000

WORKDIR /app

COPY Gemfile* ./

RUN bundle config list
RUN bundle config set without 'development test'
RUN bundle install

# uninstall our build dependencies
RUN apk del build-dependencies

ENTRYPOINT ["/sbin/tini", "--"]

# Why should this go into `base` instead of `prod` stage?
# CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]

## Development

FROM base as dev

ENV RAILS_ENV=development

RUN bundle config list
RUN bundle config --delete without
RUN bundle config --delete with
RUN bundle install

# uninstall our build dependencies
RUN apk del build-dependencies

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

USER nobody

CMD ["rails", "server", "-b", "0.0.0.0"]

## Test

FROM dev as test

COPY . .

RUN rspec

## Pre-Production

FROM test as pre-prod

USER root

RUN rm -rf ./spec

## Production

FROM base as prod

COPY --from=pre-prod /app /app

HEALTHCHECK CMD curl http://127.0.0.1/ || exit 1

USER nobody

CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
