class AddToFromLocationsToMilage < ActiveRecord::Migration
  def change
    add_column(:mileages, :from_adress, :string)
    add_column(:mileages, :to_adress, :string)
  end
end
