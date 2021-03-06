class ReportsController < ApplicationController
  include CSVDownload

  def index
    @filters = EntryFilter.new(params[:entry_filter])
    
    @hours_entries = entries(Hour.query(params[:entry_filter])).
                     page(params[:hours_pages]).per(20)
    
    @mileages_entries = entries(Mileage.query(params[:entry_filter])).
                        page(params[:mileages_pages]).per(20)
    
    @expenses_entries = entries(Expense.query(params[:entry_filter])).
                        page(params[:mileages_pages]).per(20)

    respond_to do |format|
      format.html
      format.csv do
        send_csv(
          name: current_subdomain || "export",
          type: params[:type],
          hours_entries: entries(Hour.query(params[:entry_filter])),
          mileages_entries: entries(Mileage.query(params[:entry_filter])),
          expenses_entries: entries(Expense.query(params[:entry_filter]))
        )
      end
    end
  end
  
  def wage
    respond_to do |format|
      format.csv do
        wage_csv(
          name: "wage_report",
          year:  params[:date][:year],
          month: params[:date][:month]
          )
      end
    end
  end

  private

  def entries(entries)
    if params[:format] == "csv"
      entries
    else
      entries.page(params[:page]).per(20)
    end
  end
end
