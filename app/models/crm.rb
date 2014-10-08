# == Schema Information
#
# Table name: crms
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  donation_page_name :string(255)
#  host               :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  platform           :string(255)
#  default_currency   :string(255)      default("USD")
#

class Crm < ActiveRecord::Base
  belongs_to :organization

  has_many :import_stubs

  validates :username, :host, :platform, :default_currency, presence: true
  validates :donation_page_name, presence: true, if: :requires_donation_page?
  validates :password, presence: true, on: :create
  validates :organization, presence: true

  accepts_nested_attributes_for :import_stubs, allow_destroy: true

  attr_encrypted :password, key: ENV["ENCRYPTOR_SECRET_KEY"]

  PLATFORMS = { 'actionkit' => 'ActionKit', 'bluestate' => 'Blue State Digital'}

  before_save :ignore_password_if_not_given, on: :update

  def requires_donation_page?
    # TODO this is beginning to suggest that subclasses would make sense?
    self.platform == 'actionkit'
  end

  private

  def ignore_password_if_not_given
    unless password.present?
      self.password = self.class.find(id).password
    end
  end

end
