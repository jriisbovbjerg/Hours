class AssignmentsController < ApplicationController
  before_action :find_assignment, only: [:edit, :update, :destroy]

  def index
    @assignment = Assignment.new
    @assignments = Assignment.all
  end

  def new
    @user = User.find_by_slug(params[:user]) 
    @project = Project.find_by_slug(params[:project])
    @assignment = Assignment.new(user: @user, project: @project)
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to assignments_path, notice: t(:assignment_created)
    else
      @assignments = Assignment.all
      render "assignments/index"
    end
  end

  def edit
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to assignments_path, notice: t(:assignment_updated)
    else
      render :edit
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: t(:assignment_deleted)
  end
  
  private

  def find_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:project_id, :user_id, :hourly_rate, :currency, :valid_from, :valid_to)
  end
end
