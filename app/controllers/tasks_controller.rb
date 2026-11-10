class TasksController < ApplicationController
  before_action :authenticate_user!, except: [ :public_index, :show ]
  before_action :set_view_mode, only: [ :index, :public_index ]
  before_action :set_own_task, only: [ :edit, :update, :destroy ]

  def index
    @tasks = current_user.tasks
    @tasks = @tasks.search(params[:query]) if params[:query].present?
    @tasks = @tasks.order(due_date: :asc)
    @user = current_user
  end

  def public_index
    @tasks = Task.where(visibility: 0)
    @tasks = @tasks.search(params[:query]) if params[:query].present?
    @tasks = @tasks.order(due_date: :asc)
  end

  def show
    @task = Task.find(params[:id])
    @showuser = @task.visibility < 2 || current_user&.id == @task.user_id
    @comments = Comment.where(task_id: @task.id, parent_id: nil)
    @recentComments = @comments.order(created_at: :desc)
    @current_user = current_user
  end

  def new
    @task = Task.new
    @user = current_user
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.title.present? && @task.body.present? && @task.save
      redirect_to tasks_path(@task), notice: "Task was successfully created."
    else
      @task.errors.add(:title, "can't be blank") if @task.title.blank?
      @task.errors.add(:body, "can't be blank") if @task.body.blank?
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted."
  end

  private

  # Looks the task up among the signed-in user's own tasks, so a task that
  # belongs to someone else is a 404 rather than something they can change.
  def set_own_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :visibility, :body, :due_date, :completed)
  end

  def set_view_mode
    if params[:view].present? && %w[grid list].include?(params[:view])
      session[:view_mode] = params[:view]
    end

    @view_mode = session[:view_mode] || "grid"
  end
end
