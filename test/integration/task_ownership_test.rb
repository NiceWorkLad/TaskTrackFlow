require "test_helper"

# Signed-in users must only be able to edit, update and delete their OWN tasks.
# Bob is signed in and tries to change Alice's public task, whose id he could
# copy from the public feed.
class TaskOwnershipTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :tasks

  setup do
    @task = tasks(:alices_task)
    sign_in users(:bob)
  end

  test "can't open the edit form for someone else's task" do
    get edit_task_path(@task)

    assert_response :not_found
  end

  test "can't update someone else's task" do
    patch task_path(@task), params: { task: { title: "Changed by Bob" } }

    assert_response :not_found
    assert_equal "Alice's task", @task.reload.title
  end

  test "can't delete someone else's task" do
    assert_no_difference("Task.count") do
      delete task_path(@task)
    end

    assert_response :not_found
  end

  test "the owner can still update their own task" do
    sign_in users(:alice)

    patch task_path(@task), params: { task: { title: "Changed by Alice" } }

    assert_redirected_to task_path(@task)
    assert_equal "Changed by Alice", @task.reload.title
  end
end
