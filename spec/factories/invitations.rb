FactoryGirl.define do
  factory :invitation do
    recipient_email { Faker::Internet.email }
    association :sender, factory: :user
    organization
  end
end
