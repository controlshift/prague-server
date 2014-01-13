class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :public_key
      t.string :private_key
      t.string :merchant_public_id
      t.string :client_side_encryption_key
      t.string :name

      t.timestamps
    end
  end
end
