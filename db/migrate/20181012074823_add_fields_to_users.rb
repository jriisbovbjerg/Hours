class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column(:users, :currency, :string, default: "DKK")
    change_column_null(:users, :currency, false)

    add_column(:users, :homeadress, :string, default: "home_adress")
    change_column_null(:users, :homeadress, false)

    add_column(:users, :workadress, :string, default: "work_adress")
    change_column_null(:users, :workadress, false)

    add_column(:users, :weeklyhours, :decimal, precision: 10, scale: 2, default: 37.0)
    change_column_null(:users, :weeklyhours, false)
  end
end
