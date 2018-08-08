class AddToFromLocationsToMilage < ActiveRecord::Migration
  def change
    add_column(:mileages, :from_adress, :string)
    change_column_null(:mileages, :from_adress, false, default: "from adress")
    
    add_column(:mileages, :to_adress, :string)
    change_column_null(:mileages, :to_adress, false, default: "to _adress")
    
    add_column(:mileages, :taxfree, :boolean, default: false)
  end
end
