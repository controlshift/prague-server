
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :organization do
    name 'Org'
    email { generate(:email) }
    access_token 'x'
    stripe_publishable_key 'x'
    stripe_user_id 'x'
    confirmed_at { Time.now }
    confirmation_sent_at { Time.now - 1.day }
    confirmation_token "XXXX"
    password 'password'
    password_confirmation 'password'
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
  end

  factory :tag_namespace do
    namespace { generate(:namespace) }
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
