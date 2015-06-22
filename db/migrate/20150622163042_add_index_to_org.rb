class AddIndexToOrg < ActiveRecord::Migration
  def change
    add_index :organizations, :stripe_user_id
  end
end
