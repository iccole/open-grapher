source "https://rubygems.org"

gem "rails", "~> 8.1.2"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Open graph parsing
gem "open_graph_reader"
gem "faraday-follow_redirects"
gem "faraday-cookie_jar"

# Background jobs + Redis
gem "sidekiq"
gem "redis"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end

group :development do
  gem "web-console"
end
