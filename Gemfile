# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails',                    '~> 6.1', '>= 6.1.4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap',                 '>= 1.4.4', require: false

gem 'graphql',                  '~> 1.12.4'

gem 'jbuilder',                 '~> 2.7'

gem 'pg',                       '~> 1.2', '>= 1.2.3'
gem 'puma',                     '~> 4.3.5'

gem 'rack-cors',                '~> 1.0'

gem 'sass-rails',               '>= 6'

group :development, :test do
  gem 'byebug',                 '~> 11.1', '>= 11.1.3'

  gem 'rspec-rails',            '~> 4.0', '>= 4.0.1'
end

group :development do
  gem 'graphiql-rails',         '~> 1.7'

  gem 'listen',                 '~> 3.3'

  gem 'rack-mini-profiler',     '~> 2.3', '>= 2.3.1'

  gem 'spring',                 '~> 2.1', '>= 2.1.1'

  gem 'web-console',            '>= 4.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
