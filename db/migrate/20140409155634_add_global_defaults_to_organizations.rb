class AddGlobalDefaultsToOrganizations < ActiveRecord::Migration[4.2]
  def up
    add_column :organizations, :global_defaults, :hstore
  end

  def down
    remove_column :organizations, :global_defaults
  end
end
