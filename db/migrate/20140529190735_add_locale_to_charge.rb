class AddLocaleToCharge < ActiveRecord::Migration
  def change
    add_column :charges, :locale, :string, default: 'en'
  end
end
