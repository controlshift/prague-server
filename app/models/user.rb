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

class User < ActiveRecord::Base
  devise :rememberable, :trackable, :database_authenticatable, :validatable, :confirmable, :recoverable, :registerable

  belongs_to :organization
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'sender_id'
  has_one :invitation, foreign_key: 'recipient_id'

  accepts_nested_attributes_for :organization

  validates :email, presence: true, email_format: true
end
