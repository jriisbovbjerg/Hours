class EntriesController < ApplicationController
  include CSVDownload

  DATE_FORMAT = "%d/%m/%Y".freeze

  def index
    @user = User.find_by_slug(params[:user_id])
    
    @projects = Assignment.by_user(@user).includes(:project).map(&:project).flatten
    @projects = @projects + Project.administrative
    @projects = Project.all

    @hours_entry = Hour.new
    @mileages_entry = Mileage.new
    @expenses_entry = Expense.new
    
    @hours_entries = @user.hours.by_date.page(params[:hours_pages]).per(20)
    @mileages_entries = @user.mileages.by_date.page( params[:mileages_pages]).per(20)
    @expenses_entries = @user.expenses.by_date.page( params[:expenses_pages]).per(20)

    @activities = Hour.by_last_created_at.limit(30)

    respond_to do |format|
      format.html { @mileages_entries + @hours_entries + @expenses_entries}
      format.csv do
        send_csv(
          name: @user.name.gsub(/\s+/, "_"),
          type: "general",
          hours_entries: @user.hours.by_date,
          mileages_entries: @user.mileages.by_date,
          expenses_entries: @user.expenses.by_date)
      end
    end
  end

  def destroy
    resource.destroy
    redirect_to user_entries_path(current_user) + "##{controller_name}",
                notice: t("entry_deleted.#{controller_name}")
  end

  def edit
    @entry_type = set_entry_type
  end

  private

  def set_entry_type
    params[:controller]
  end

  def parsed_date(entry_type)
    Date.strptime(params[entry_type][:date], DATE_FORMAT)
  end
end
