class AddAmountToExpense < ActiveRecord::Migration
  def self.up
    add_column(:expenses, :amount, :decimal, precision: 10, scale: 2)
    Expense.update_all("amount = value")
    Expense.update_all("value = amount * exchangerate")
    change_column_null(:expenses, :amount, false)
  end

  def self.down
    remove_column(:expenses, :amount)
  end
end
