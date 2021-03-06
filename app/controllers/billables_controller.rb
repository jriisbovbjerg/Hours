class BillablesController < ApplicationController
  def index
    @filters = EntryFilter.new(params[:entry_filter])

    @projects = projects_with_billable_entries
  end

  def show 
    resource
  end

  def bill_entries

    invoice = Invoice.new.generate(params)

    
    if params[:hours_to_bill]
      Hour.where(id: params[:hours_to_bill]).update_all("billed = true")
    end

    if params[:mileages_to_bill]
      Mileage.where(id: params[:mileages_to_bill]).update_all("billed = true")
    end

    if params[:expenses_to_bill]
      Expense.where(id: params[:expenses_to_bill]).update_all("billed = true")
    end
    render json: nil, status: 200
  end

  private

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end
  
  def projects_with_billable_entries
    billable_projects = Project.where(billable: true, archived: false)

    billable_projects.select do |project|
      project if project.has_billable_entries?
    end
  end
end
