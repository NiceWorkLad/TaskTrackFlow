class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @task
    else
      redirect_to @task, alert: "Comment could not be added at this time."
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
    end

    redirect_to @task
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
