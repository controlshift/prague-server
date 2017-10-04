class AddConfigToCharges < ActiveRecord::Migration[4.2]
  def up
    add_column :charges, :config, :hstore
  end

  def down
    remove_column :charges, :config
  end
end
