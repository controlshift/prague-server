class Crm < ActiveRecord::Base
  belongs_to :organization

  validates :password, :username, :host, :donation_page_name, presence: true

  attr_encrypted :password, key: ENV["ENCRYPTOR_SECRET_KEY"]
end
