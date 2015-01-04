class AddAcceptedAtToInvitations < ActiveRecord::Migration
  def change
    add_column :users, :invitation_accepted_at, :datetime
  end
end
