FactoryGirl.define do
  factory :organization do
    name 'Org'
    email 'org@org.com'
    access_token 'x'
    stripe_publishable_key 'x'
    stripe_user_id 'x'
    confirmed_at { Time.now }
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
