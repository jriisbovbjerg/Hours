class ChangeProjectValidToDate < ActiveRecord::Migration
  def change
    change_column_null(:projects, :valid_from, true)
    change_column_null(:projects, :valid_to, true)

    change_column_default(:projects, :valid_to, nil)
    change_column_default(:projects, :valid_from, nil)

    change_column :projects, :valid_to, "date USING CAST(valid_to AS date)"
    change_column :projects, :valid_from, "date USING CAST(valid_from AS date)"
  end
end
