class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @task }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html do
        redirect_to @task, alert: "Comment could not be added at this time."
      end

      format.turbo_stream do
        redirect_to @task, alert: "Comment could not be added at this time."
      end
    end
  end
end

  def destroy
    @comment = @task.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task }
      end
    else
      redirect_to @task, alert: "You cannot delete this comment."
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])

    # Private tasks (visibility 2) are only open to their owner, same as tasks#show
    if @task.visibility >= 2 && @task.user_id != current_user.id
      redirect_to tasks_path, alert: "You do not have permission to view this task."
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
