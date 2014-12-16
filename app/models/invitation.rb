# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  sender_id       :integer          not null
#  recipient_id    :integer
#  recipient_email :string(255)      not null
#  organization_id :integer          not null
#  token           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :organization
  has_one :recipient, class_name: 'User'

  validates :sender, presence: true
  validates :recipient_email, presence: true
  validates :organization, presence: true
  validate :recipient_is_not_member
  validate :sender_is_member

  before_validation :generate_token!

  private

  # Check if recipient isn't already a member of some organization
  def recipient_is_not_member
    recipient = User.where(email: recipient_email).first if recipient_email.present?
    errors.add :recipient_email, 'is already member of an organization' if !recipient.nil? && !recipient.organization.nil?
  end

  # Check if sender is member of the organization
  def sender_is_member
    if sender_id.present?
      errors.add :sender_id, 'only members of the organization can invite new users' if User.find(sender_id).organization_id != organization_id
    end
  end

  def generate_token!
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
