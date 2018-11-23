class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      add_column :payload, :options, :jsonb, null: false, default: '{}'

      t.timestamps null: false
    end
  end
end
