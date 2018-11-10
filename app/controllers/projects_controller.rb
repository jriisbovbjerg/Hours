include TimeSeriesInitializer

class ProjectsController < ApplicationController
  def index
    @projects = Project.unarchived.by_last_updated.page(params[:page]).per(7)
    
  end

  def show
    @time_series = time_series_for(resource)
  end

  def edit
    resource
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: t(:project_created)
    else
      render action: "new"
    end
  end

  def update
    if resource.update_attributes(project_params)
      redirect_to project_path(resource), notice: t(:project_updated)
    else
      render action: "edit"
    end
  end

  private

  def entry_type
    "mileages" if request.fullpath == mileage_entry_path
    "hours" if request.fullpath == hours_entry_path
    "expenses" if request.fullpath == expense_entry_path
  end

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end

  def project_params
    params.require(:project).
      permit(:name, :billable, :client_id, :contact_id,
             :archived, :description, :budget, :currency,
             :period, :valid_from, :valid_to, :invoice_email,
             :reference_number)
  end
end
