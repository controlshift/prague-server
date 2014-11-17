class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id, null: false, index: true
      t.integer :recipient_id
      t.string :recipient_email, null: false
      t.integer :organization_id, null: false, index: true
      t.string :token, index: true

      t.timestamps
    end
  end
end
