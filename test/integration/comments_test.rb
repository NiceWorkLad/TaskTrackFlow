require "test_helper"

class CommentsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner = User.create!(email: "owner@example.com", username: "owner", password: "password123")
    @other = User.create!(email: "other@example.com", username: "other", password: "password123")
    @public_task = @owner.tasks.create!(title: "Public", description: "desc", visibility: 0)
    @private_task = @owner.tasks.create!(title: "Private", description: "desc", visibility: 2)
  end

  test "signed-in user can comment on a public task" do
    sign_in @other

    assert_difference -> { @public_task.comments.count }, 1 do
      post task_comments_path(@public_task), params: { comment: { body: "Hi" } }, as: :turbo_stream
    end
    assert_response :success
  end

  test "guests cannot comment" do
    assert_no_difference -> { Comment.count } do
      post task_comments_path(@public_task), params: { comment: { body: "Hi" } }
    end
  end

  test "other users cannot comment on a private task" do
    sign_in @other

    assert_no_difference -> { Comment.count } do
      post task_comments_path(@private_task), params: { comment: { body: "Hi" } }
    end
    assert_redirected_to tasks_path
  end

  test "owner can comment on their private task" do
    sign_in @owner

    assert_difference -> { @private_task.comments.count }, 1 do
      post task_comments_path(@private_task), params: { comment: { body: "Note" } }
    end
  end

  test "replies must be to a top-level comment on the same task" do
    parent = @public_task.comments.create!(user: @owner, body: "Parent")
    reply = @public_task.comments.create!(user: @owner, body: "Reply", parent: parent)
    other_task_comment = @owner.tasks.create!(title: "Other", description: "d")
                               .comments.create!(user: @owner, body: "Elsewhere")

    assert_not @public_task.comments.build(user: @owner, body: "x", parent: reply).valid?
    assert_not @public_task.comments.build(user: @owner, body: "x", parent: other_task_comment).valid?
    assert @public_task.comments.build(user: @owner, body: "x", parent: parent).valid?
  end

  test "only the author can delete a comment" do
    comment = @public_task.comments.create!(user: @owner, body: "Mine")
    sign_in @other

    assert_no_difference -> { Comment.count } do
      delete task_comment_path(@public_task, comment)
    end

    sign_in @owner
    assert_difference -> { Comment.count }, -1 do
      delete task_comment_path(@public_task, comment), as: :turbo_stream
    end
  end

  test "deleting a reply and a parent with replies both succeed" do
    parent = @public_task.comments.create!(user: @owner, body: "Parent")
    reply = @public_task.comments.create!(user: @owner, body: "Reply", parent: parent)
    @public_task.comments.create!(user: @owner, body: "Reply 2", parent: parent)
    sign_in @owner

    delete task_comment_path(@public_task, reply), as: :turbo_stream
    assert_response :success

    assert_difference -> { Comment.count }, -2 do
      delete task_comment_path(@public_task, parent), as: :turbo_stream
    end
  end

  test "show page renders comments and replies for guests and signed-in users" do
    parent = @public_task.comments.create!(user: @owner, body: "Parent body")
    @public_task.comments.create!(user: @other, body: "Reply body", parent: parent)

    get task_path(@public_task)
    assert_response :success
    assert_match "Parent body", response.body
    assert_match "Reply body", response.body

    sign_in @other
    get task_path(@public_task)
    assert_response :success
    assert_select %(meta[name="current-user-id"][content="#{@other.id}"])
    assert_select %([data-viewer-owner-id-value="#{@owner.id}"])
  end
end
