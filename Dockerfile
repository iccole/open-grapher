ARG RUBY_VERSION=3.4.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl build-essential git libyaml-dev pkg-config libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile Gemfile.lock ./
COPY vendor/ ./vendor/
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
