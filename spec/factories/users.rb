FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'aaaaaaaa'
    password_confirmation 'aaaaaaaa'

    factory :confirmed_user do
      confirmed_at { Time.now }
      confirmation_sent_at { Time.now - 1.day }

      factory :user_with_organization do
        organization
      end
    end
  end
end