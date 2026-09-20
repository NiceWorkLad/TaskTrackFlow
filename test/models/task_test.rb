require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "creates a task with a UUID id" do
    task = Task.create!

    assert task.persisted?
    assert_match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i, task.id)

    another_task = Task.create!
    assert_not_equal task.id, another_task.id

    assert_equal "/tasks/#{task.id}", tasks_path(task)
  end

  test "edits a task to visibility 2" do
    task = Task.create!

    task.update!(visibility: 2)

    assert_equal 2, task.reload.visibility
  end

  test "non-owner cannot see a private task" do
    owner = User.create!
    non_owner = User.create!
    task = Task.create!(user: owner, visibility: 2)

    assert_not TaskPolicy.new(non_owner, task).show?
  end
end
