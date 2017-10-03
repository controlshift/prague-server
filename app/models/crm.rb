# == Schema Information
#
# Table name: crms
#
#  id                    :integer          not null, primary key
#  organization_id       :integer
#  donation_page_name    :string
#  host                  :string
#  username              :string
#  created_at            :datetime
#  updated_at            :datetime
#  platform              :string
#  default_currency      :string           default("USD")
#  encrypted_password    :string
#  encrypted_password_iv :string
#

class Crm < ActiveRecord::Base
  belongs_to :organization

  has_many :import_stubs, dependent: :destroy

  validates :username, presence: true
  validates :host, presence: true, host_name: true, format: /\A(?!http(s?):\/\/).+\z/
  validates :platform, presence: true
  validates :default_currency, presence: true
  validates :donation_page_name, presence: true, if: :requires_donation_page?
  validates :password, presence: true, on: :create
  validates :organization, presence: true
  validates :platform, presence: true, inclusion: {in: ['actionkit', 'bluestate']}
  accepts_nested_attributes_for :import_stubs, allow_destroy: true

  attr_encrypted :password, key: ENV["ENCRYPTOR_SECRET_KEY"]

  PLATFORMS = { 'actionkit' => 'ActionKit', 'bluestate' => 'Blue State Digital'}

  before_save :ignore_password_if_not_given, on: :update

  def platform_display_name
    PLATFORMS[platform]
  end

  def requires_donation_page?
    action_kit?
  end

  def action_kit?
    self.platform == 'actionkit'
  end

  def blue_state_digital?
    self.platform == 'bluestate'
  end

  private

  def ignore_password_if_not_given
    unless password.present?
      self.password = self.class.find(id).password
    end
  end

end
