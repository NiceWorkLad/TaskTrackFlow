class TasksController < ApplicationController
  before_action :authenticate_user!, except: [:public_index, :show]
  before_action :set_view_mode, only: [:index, :public_index]

  def index
        @tasks = current_user.tasks.order(due_date: :asc)

    @user = current_user

    if @user
      @tasks = @user.tasks
    end
  end

  def public_index
    @tasks = Task.where(public: true)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
  @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path(@task), notice: "Task was successfully created."
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted."
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :public, :body, :due_date, :completed)
  end

  def set_view_mode
    if params[:view].present? && %w[grid list].include?(params[:view])
      session[:view_mode] = params[:view]
    end

    @view_mode = session[:view_mode] || "list"
  end
end
