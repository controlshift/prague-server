class TagNameIndexesShouldBeUnique < ActiveRecord::Migration[4.2]
  disable_ddl_transaction!

  def change
    remove_index :tags, [:organization_id, :name]
    remove_index :tag_namespaces, [:organization_id, :namespace]

    add_index :tags, [:organization_id, :name], algorithm: :concurrently, unique: true
    add_index :tag_namespaces, [:organization_id, :namespace], algorithm: :concurrently, unique: true
  end
end
