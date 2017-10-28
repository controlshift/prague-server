# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE']) \

env = ENV['RAILS_ENV'] || 'development'
if env == 'development'
  # This code has made it into rails for the next release, but as of summer 2017 is still considered
  # a beta version, so only running it in development mode for now.
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end


