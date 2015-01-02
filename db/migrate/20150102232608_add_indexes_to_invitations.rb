class AddIndexesToInvitations < ActiveRecord::Migration
  def change
    add_index :invitations, :organization_id
    add_index :invitations, :sender_id
    add_index :invitations, :token, unique: true
  end
end
