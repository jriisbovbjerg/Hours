class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :user,       index: true, null: false
      t.references :project,    index: true, null: false
      t.date       :valid_from, index: true, null: false
      t.date       :valid_to,   index: true, null: false
      t.string     :currency,                null: false, default: "DKK"
      t.decimal    :hourly_rate,             null: false, default: 0, precision: 10, scale: 2
      t.boolean    :active,                  null: false, default: true
      t.timestamps
    end
  end
end
