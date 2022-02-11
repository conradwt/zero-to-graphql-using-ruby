# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails',                    '~> 7.0.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap',                 '>= 1.9.3', require: false

gem 'graphql',                  '~> 1.13.2'

gem 'pg',                       '~> 1.2', '>= 1.2.3'
gem 'puma',                     '~> 5.6'

gem 'rack-cors',                '~> 1.0'

gem 'sprockets-rails',          '~> 3.4', '>= 3.4.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  gem 'rspec-rails',            '~> 5.0.2'
end

group :development do
  gem 'graphiql-rails',         '~> 1.7'

  gem 'rack-mini-profiler',     '~> 2.3', '>= 2.3.3'

  gem 'web-console',            '~> 4.2'
end
