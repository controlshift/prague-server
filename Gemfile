source 'https://rubygems.org'
ruby '2.1.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'compass-rails'
gem 'bootstrap-sass'
gem 'honeybadger'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'omniauth'
gem 'omniauth-stripe-connect', git: 'https://github.com/todddickerson/omniauth-stripe-connect.git'
gem 'stripe'
gem 'stripe_event', git: 'https://github.com/controlshift/stripe_event.git'
gem 'haml-rails'
gem 'doorkeeper'


gem 'pusher'

gem 'sidekiq'

gem 'sinatra', '>= 1.3.0', :require => nil

gem 'rack-cors', :require => 'rack/cors'

gem 'devise'
gem 'attr_encrypted'

gem 'action_kit_rest', git: 'https://github.com/controlshift/action_kit_rest.git'
gem 'blue_state_digital', git: 'https://github.com/controlshift/blue_state_digital.git'

gem 'rack-cache'
gem 'dalli'
gem 'sprockets', '~> 2.11.0'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'geoip'
gem 'will_paginate'

gem 'activeadmin', github: 'gregbell/active_admin'

gem 'cocoon'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'letter_opener'
  gem 'quiet_assets'
end


group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'byebug'
  gem 'mailcatcher'
  gem 'thin'
end

group :test do
  gem 'guard'
  gem 'guard-spring'
  gem 'guard-rspec', require: false
  gem 'stripe-ruby-mock', git: 'https://github.com/controlshift/stripe-ruby-mock.git'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'capybara', '~> 2.1'
  gem 'shoulda-matchers', require: false
  gem 'selenium-webdriver'
  gem "capybara-webkit", require: false
  gem "capybara-email"
  gem "poltergeist"
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'memcachier'
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end
