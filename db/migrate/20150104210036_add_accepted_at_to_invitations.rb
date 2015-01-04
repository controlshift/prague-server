class AddAcceptedAtToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :invitation_accepted_at, :datetime
  end
end
