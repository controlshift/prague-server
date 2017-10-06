class AddPaidToCharges < ActiveRecord::Migration[4.2]
  def change
    add_column :charges, :paid, :boolean, default: false, null: false
  end
end
