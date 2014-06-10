
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
    email 'rex@exxon.com'
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
    organization
  end
end
