FactoryGirl.define do
  factory :organization do
    name 'Org'
    access_token 'x'
    stripe_publishable_key 'x'
    stripe_user_id 'x'
  end
end