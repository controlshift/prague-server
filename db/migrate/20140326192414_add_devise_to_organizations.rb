class AddDeviseToOrganizations < ActiveRecord::Migration[4.2]
  def self.up
    change_table(:organizations) do |t|

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
