class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string     :name, null: false
      t.date       :from_date, index: true, null: false
      t.date       :to_date,   index: true, null: false
      t.references :project, index: true, null: false
      t.jsonb      :payload, null: false, default: '{}'

      t.timestamps null: false
    end

    add_index :invoices, :payload, using: :gin
  end
end
