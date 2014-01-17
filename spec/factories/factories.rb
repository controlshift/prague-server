FactoryGirl.define do
  factory :organization do
    name 'Org'
    access_token 'x'
    stripe_publishable_key 'x'
    stripe_user_id 'x'
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
  end
end