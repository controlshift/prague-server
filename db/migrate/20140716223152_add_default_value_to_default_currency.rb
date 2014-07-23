class AddDefaultValueToDefaultCurrency < ActiveRecord::Migration
  def up
    change_column :crms, :default_currency, :string, default: "USD"
  end

  def down
    change_column :crms, :default_currency, :string, default: nil
  end
end
