class ExpensesController < EntriesController
  def create
    @entry = Expense.new(entry_params)
    @entry.user = current_user

    if @entry.save
      redirect_to root_path + "##{controller_name}", notice:
        t("entry_created.expenses")
    else
      redirect_to root_path + "##{controller_name}", notice:
        @entry.errors.full_messages.join(". ")
    end
  end

  def update
    if resource.update_attributes(entry_params)
      redirect_to user_entries_path(current_user) + "#expenses",
                  notice: t("entry_saved")
    else
      redirect_to edit_expense_path(resource), notice: t("entry_failed")
    end
  end

  def edit
    super
    resource
  end

  private

  def resource
    @expenses_entry ||= current_user.expenses.find(params[:id])
  end

  def entry_params
    params.require(:expense).
      permit(:project_id, :amount, :value, :date, :currency, :exchangerate, :description, :supplier).
      merge(date: parsed_date(:expense))
  end
end