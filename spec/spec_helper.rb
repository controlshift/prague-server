# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'pry'
require 'sidekiq/testing'
require 'shoulda/matchers'
require 'stripe_mock'
require 'webmock/rspec'
require 'support/features/user_helpers'
require 'oauth2'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, type: :controller
  config.include Features::UserHelpers, type: :feature

  config.before(:each) do
    Sidekiq::Testing.disable!
    PragueServer::Application.redis.flushdb

    allow_any_instance_of(OAuth2::Client).to receive(:get_token).and_return(OAuth2::AccessToken.new(nil,nil,{'stripe_public_key' => 'xxx'}))

    stub_request(:post, /api.pusherapp.com/).
      with(headers: {'Accept'=>'*/*'}).
      to_return(status: 201, body: "stubbed response", headers: {})
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:transaction)
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean_with(:transaction)
  end

  WebMock.disable_net_connect!(:allow_localhost => true)

  OmniAuth.config.test_mode = true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.include FactoryGirl::Syntax::Methods
  config.order = "random"

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec

      with.library :rails
    end
  end
end
