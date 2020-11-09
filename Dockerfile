## Base

FROM ruby:2.7.2-slim as base

RUN groupadd --gid 1000 nobody \
  && useradd --uid 1000 --gid nobody --shell /bin/bash --create-home nobody

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

ENV RAILS_ENV=production

EXPOSE 3000
ENV PORT 3000

WORKDIR /app

COPY Gemfile* ./

RUN bundle config list
RUN bundle config set without 'development test'
# RUN bundle install --without development test --deployment

ENV PATH ./bin:$PATH
ENV TINI_VERSION v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]

# Why should this go into `base` instead of `prod` stage?
# CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]

## Development

FROM base as dev

ENV RAILS_ENV=development

RUN apt-get update -qq && apt-get install -qq \
  --no-install-recommends \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  libfontconfig \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

RUN bundle config list
RUN bundle config --delete without
RUN bundle config --delete with
RUN bundle install

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

# ARG MICROSCANNER_TOKEN
# ADD https://get.aquasec.com/microscanner /

# USER root

# RUN chmod +x /microscanner
# RUN /microscanner $MICROSCANNER_TOKEN --continue-on-failure

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
