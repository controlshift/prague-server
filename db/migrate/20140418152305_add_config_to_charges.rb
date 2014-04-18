class AddConfigToCharges < ActiveRecord::Migration
  def up
    add_column :charges, :config, :hstore
  end

  def down
    remove_column :charges, :config
  end
end
