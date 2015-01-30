FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :organization_name do |n|
    "Org #{n}"
  end

  factory :organization do
    name { generate(:organization_name) }
    access_token 'x'
    stripe_publishable_key 'x'
    stripe_user_id 'x'
    currency 'USD'
  end

  factory :customer do
    first_name 'Rex'
    last_name 'Tillerson'
    email { generate(:email) }
    zip '90004'
    country 'US'
  end

  factory :charge do
    currency 'usd'
    amount 1000
    organization
    customer
    card { {id: '123', brand: 'visa'} }
    pusher_channel_token 'xxx'
  end

  factory :crm do
    password 'something'
    host 'blah.actionkit.com'
    platform 'actionkit'
    username 'foo'
    donation_page_name 'my_special_donation_page'
    default_currency 'USD'
    organization
  end

  factory :import_stub do
    donation_currency 'GBP'
    payment_account 'GBP Import Stub'
    crm
  end

  factory :tag do
    name { "#{Faker::Lorem.word}:#{Faker::Lorem.word}" }
    organization
  end

  factory :tag_namespace do
    namespace { generate(:namespace) }
    organization
  end

  factory :webhook_endpoint do
    name { generate(:name) }
    url 'http://www.google.com/'
    organization
  end

  sequence :name do |n|
    "name#{n}"
  end

  sequence :namespace do |n|
    "name#{n}"
  end

  sequence :application_name do |n|
    "app#{n}"
  end

  factory :doorkeeper_application,  class: Doorkeeper::Application do
    name { generate(:application_name) }
  end
end
