class AddSlugToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :slug, :string
  end
end
