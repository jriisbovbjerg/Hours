class ChangeHoursType < ActiveRecord::Migration
  def change
    change_column :hours, :value, :decimal, :precision => 10, :scale => 2
  end
end
