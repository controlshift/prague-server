source 'https://rubygems.org'
ruby '2.4.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'compass-rails'
gem 'bootstrap-sass'
gem 'sentry-raven'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'omniauth'
gem 'omniauth-stripe-connect'
gem 'stripe', '1.58.0'
gem 'stripe_event', git: 'https://github.com/controlshift/stripe_event.git'
gem 'haml-rails'
gem 'doorkeeper'
gem 'cancancan'

gem 'pusher'

gem 'sidekiq'
gem 'redis-namespace'

# database admin
gem 'pghero'
gem 'blazer'
# required by blazer for background query processing.
gem 'sucker_punch'

gem 'rack-cors', :require => 'rack/cors'

gem 'devise'
gem 'attr_encrypted', "~> 3.0.0"

gem 'action_kit_rest', git: 'https://github.com/controlshift/action_kit_rest.git'
gem 'blue_state_digital', git: 'https://github.com/controlshift/blue_state_digital.git'

gem 'rack-cache'
gem 'dalli'
gem 'sprockets'
gem 'simple_form'
gem 'geoip'
gem 'will_paginate'

gem 'going_postal'
gem 'httparty'
gem 'analytics-ruby'
gem 'bootsnap', require: false

group :development do
  gem 'letter_opener'
end

group :development, :test do
  gem 'brakeman', :require => false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'byebug'
  gem 'thin'
  gem 'faker'
end

group :test do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'stripe-ruby-mock', '2.3.1', require: 'stripe_mock'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'capybara'
  gem 'shoulda-matchers', require: false
  gem 'capybara-webkit', require: false
  gem 'capybara-email'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'memcachier'
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end
