class AddExternalIdToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :external_id, :string
    add_column :charges, :external_new_member, :boolean
  end
end
