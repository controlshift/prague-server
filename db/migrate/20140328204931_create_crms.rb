class CreateCrms < ActiveRecord::Migration
  def change
    create_table :crms do |t|
      t.belongs_to :organization, index: true
      t.string :donation_page_name
      t.string :host
      t.string :username
      t.string :encrypted_password

      t.timestamps
    end
  end
end
