class AddIndexToOrg < ActiveRecord::Migration[4.2]
  def change
    add_index :organizations, :stripe_user_id
  end
end
