source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails",                    "~> 8.1.1"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft",                "~> 1.3", ">= 1.3.1"

# Use postgresql as the database for Active Record
gem "pg",                       "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma",                     "~> 7.1"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder",                 "~> 2.14", ">= 2.14.1"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt",                 "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data",              "~> 1.2025", ">= 1.2025.2", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache",              "~> 1.0", ">= 1.0.10"
gem "solid_queue",              "~> 1.2", ">= 1.2.4"
gem "solid_cable",              "~> 3.0", ">= 3.0.12"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap",                 "~> 1.19", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal",                    "~> 2.8", ">= 2.8.2", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster",                 "~> 0.1.16", require: false

gem "graphql",                  "~> 2.3.22"

gem "rack-cors",                "~> 3.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  gem "rspec-rails",            "~> 5.1.2"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "graphiql-rails",         "~> 1.10", ">= 1.10.5"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
