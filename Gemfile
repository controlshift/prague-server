source 'https://rubygems.org'
ruby '2.3.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'compass-rails'
gem 'bootstrap-sass'
gem 'sentry-raven'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'omniauth'
gem 'omniauth-stripe-connect'
gem 'stripe'
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

gem 'rack-cors', :require => 'rack/cors'

gem 'devise'
gem 'attr_encrypted'

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

group :development do
  gem 'letter_opener'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'brakeman', :require => false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'byebug'
  gem 'mailcatcher'
  gem 'thin'
  gem 'faker'
end

group :test do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'stripe-ruby-mock', :require => 'stripe_mock'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
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
