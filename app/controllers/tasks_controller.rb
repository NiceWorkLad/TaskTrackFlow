class TasksController < ApplicationController
  def index
    @tasks = Task.all

    @user = current_user

    if @user
      @tasks = @user.tasks
    end
  end

  def public
    @userPublicTasks = current_user.tasks.where(public: true) if current_user
    @publicTasks = Task.where(public: true)
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
    params.require(:task).permit(:title, :description, :completed, :public)
  end
end
