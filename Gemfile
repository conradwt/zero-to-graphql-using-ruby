# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails',                    '~> 7.0', '>= 7.0.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap',                 '~> 1.11', '>= 1.11.1', require: false

gem 'graphql',                  '~> 2.1.0'

gem 'pg',                       '~> 1.5.4'
gem 'puma',                     '~> 5.6', '>= 5.6.7'

gem 'rack-cors',                '~> 1.1', '>= 1.1.1'

gem 'sprockets-rails',          '~> 3.4', '>= 3.4.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data',              '~> 1.2022', '>= 1.2022.1', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug',                  '~> 1.5.0', platforms: %i[ mri mingw x64_mingw ]

  gem 'rspec-rails',            '~> 5.1.2'
end

group :development do
  gem 'graphiql-rails',         '~> 1.8.0'

  gem 'rack-mini-profiler',     '~> 3.0.0'

  gem 'web-console',            '~> 4.2.0'
end
