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
#

class Crm < ActiveRecord::Base
  belongs_to :organization

  has_many :import_stubs

  validates :username, :host, :donation_page_name, :platform, :default_currency, presence: true
  validates :password, presence: true, on: :create

  accepts_nested_attributes_for :import_stubs, allow_destroy: true

  attr_encrypted :password, key: ENV["ENCRYPTOR_SECRET_KEY"]

  PLATFORMS = { 'actionkit' => 'ActionKit' }

  before_save :ignore_password_if_not_given, on: :update

  private

  def ignore_password_if_not_given
    unless password.present?
      self.password = self.class.find(id).password
    end
  end

end
