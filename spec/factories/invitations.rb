# == Schema Information
#
# Table name: invitations
#
#  id                     :integer          not null, primary key
#  sender_id              :integer          not null
#  recipient_id           :integer
#  recipient_email        :string           not null
#  organization_id        :integer          not null
#  token                  :string
#  created_at             :datetime
#  updated_at             :datetime
#  invitation_accepted_at :datetime
#

FactoryBot.define do
  factory :invitation do
    recipient_email { Faker::Internet.email }
    association :sender, factory: :user
    organization
  end
end
