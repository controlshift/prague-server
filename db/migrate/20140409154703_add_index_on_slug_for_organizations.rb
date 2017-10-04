class AddIndexOnSlugForOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_index :organizations, :slug, :unique => true
  end
end
