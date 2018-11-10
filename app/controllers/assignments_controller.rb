class AssignmentsController < ApplicationController
  before_action :find_assignment, only: [:edit, :update]

  def index
    @assignment = Assignment.new
    @assignments = Assignment.all
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

  private

  def find_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:project_id, :user_id, :hourly_rate, :currency, :valid_from, :valid_to)
  end
end
