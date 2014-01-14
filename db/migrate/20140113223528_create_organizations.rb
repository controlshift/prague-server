class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :access_token
      t.string :stripe_publishable_key
      t.string :stripe_user_id
      t.string :name

      t.timestamps
    end
  end
end
