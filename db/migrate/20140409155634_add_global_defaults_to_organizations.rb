class AddGlobalDefaultsToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :global_defaults, :hstore
  end

  def down
    remove_column :organizations, :global_defaults
  end
end
