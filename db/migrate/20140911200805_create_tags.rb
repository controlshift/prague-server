class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :organization_id
      t.timestamps
    end

    add_index :tags, [:organization_id, :name]

    create_table :charges_tags do |t|
      t.integer :tag_id
      t.integer :charge_id
    end

    add_index :charges_tags, [:tag_id, :charge_id]
  end
end
