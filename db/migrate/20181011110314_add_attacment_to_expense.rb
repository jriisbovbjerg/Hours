class AddAttacmentToExpense < ActiveRecord::Migration
  def change
    add_attachment :expenses, :receipt
  end
end
