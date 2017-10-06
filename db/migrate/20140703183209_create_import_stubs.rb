class CreateImportStubs < ActiveRecord::Migration[4.2]
  def change
    create_table :import_stubs do |t|
      t.belongs_to :crm, index: true
      t.string :payment_account
      t.string :donation_currency

      t.timestamps
    end
  end
end
