class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id, null: false
      t.integer :recipient_id
      t.string :recipient_email, null: false
      t.integer :organization_id, null: false
      t.string :token

      t.timestamps
    end
  end
end
