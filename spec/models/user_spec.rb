# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  organization_id        :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe User do
  it { should belong_to :organization }
  it { should validate_presence_of(:email)}

  describe "email addresses" do
    it { should allow_value('george@washington.com').for(:email) }
    it { should allow_value('george@ul.we.you.us').for(:email) }
    it { should_not allow_value('fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd').for(:email) }
  end
end
