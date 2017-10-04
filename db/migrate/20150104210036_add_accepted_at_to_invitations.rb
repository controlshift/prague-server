class AddAcceptedAtToInvitations < ActiveRecord::Migration[4.2]
  def change
    add_column :invitations, :invitation_accepted_at, :datetime
  end
end
