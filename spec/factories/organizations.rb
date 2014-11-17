# == Schema Information
#
# Table name: organizations
#
#  id                          :integer          not null, primary key
#  access_token                :string(255)
#  stripe_publishable_key      :string(255)
#  stripe_user_id              :string(255)
#  name                        :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  slug                        :string(255)
#  global_defaults             :hstore
#  testmode                    :boolean
#  refresh_token               :string(255)
#  stripe_live_mode            :boolean
#  stripe_publishable_test_key :string(255)
#  stripe_test_access_token    :string(255)
#

FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
  end
end
