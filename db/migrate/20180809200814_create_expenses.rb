class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :project, index: true, null: false
      t.references :user, index: true, null: false
      t.decimal    :value, null: false, precision: 10, scale: 2
      t.string     :currency, null: false, default: "DKK"
      t.decimal    :exchangerate, precision: 10, scale: 2, null: false, default: 1.0
      t.string     :supplier, null: false
      t.string     :description, null: false 
      t.date       :date, null: false
      t.boolean    :billed, default: false

      t.timestamps
    end

    add_index(:expenses, :billed)
    add_index(:expenses, :date)
  end
end
