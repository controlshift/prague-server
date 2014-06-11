class AddPaidToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :paid, :boolean, default: false, null: false
  end
end
