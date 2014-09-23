class AddTagNamespaces < ActiveRecord::Migration
  def change
    create_table :tag_namespaces do |t|
      t.string :namespace
      t.timestamps
    end

    add_column :tags, :namespace_id, :integer
    add_index :tags, [:organization_id, :namespace_id]
  end
end
