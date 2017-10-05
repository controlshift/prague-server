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

class Invitation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :organization
  has_one :recipient, class_name: 'User'

  validates :sender, presence: true
  validates :recipient_email, presence: true, email_format: true
  validates :organization, presence: true
  validate :recipient_is_not_member
  validate :sender_is_member
  validates :token, presence: true, uniqueness: true

  attr_readonly :token

  before_validation :generate_token!

  private

  # Check if recipient isn't already a member of some organization
  def recipient_is_not_member
    if recipient_email.present?
      recipient = User.where(email: recipient_email).first
      errors.add :recipient_email, 'is already member of an organization' if recipient.present? && recipient.organization.present?
    end
  end

  # Check if sender is member of the organization
  def sender_is_member
    if sender.present?
      errors.add :sender_id, 'only members of the organization can invite new users' if sender.organization != organization && !sender.admin?
    end
  end

  def generate_token!
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join) if token.blank?
  end
end
