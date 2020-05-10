# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails',                    '~> 6.0.3'

gem 'bootsnap',                 '~> 1.4', '>= 1.4.5', require: false

gem 'graphql',                  '~> 1.9'

gem 'jbuilder',                 '~> 2.7'

gem 'pg',                       '>= 0.18', '< 2.0'
gem 'puma',                     '~> 4.3.3'

gem 'sass-rails',               '>= 6'

gem 'turbolinks',               '~> 5'

gem 'webpacker',                '~> 4.0'

gem 'rack-cors',                '~> 1.0'

group :development, :test do
  gem 'byebug',                 '~> 11.0', '>= 11.0.1'
  # gem 'byebug',                 platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'graphiql-rails',         '~> 1.7'

  gem 'listen',                 '>= 3.0.5', '< 3.2'

  gem 'spring',                 '~> 2.1'
  gem 'spring-watcher-listen',  '~> 2.0.0'

  gem 'web-console',            '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
