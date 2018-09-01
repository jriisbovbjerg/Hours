class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :position, null: false, default: ""
      t.string :department, null: false, default: ""
      t.string :phone, null: false, default: ""
      t.references :client, index: true, null: false
      t.timestamps
    end
  end
end
