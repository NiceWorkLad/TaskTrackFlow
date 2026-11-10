class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :body, presence: true
  validate :parent_is_top_level_comment_on_same_task, if: :parent_id?
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies,
         class_name: "Comment",
         foreign_key: :parent_id,
         dependent: :destroy

  after_create_commit :broadcast_comment

  after_destroy_commit :broadcast_remove

  private

  def broadcast_comment
    if parent_id.present?
      broadcast_prepend_to(
      task, :comments,
      target: "replies-section-#{parent_id}",
      partial: "comments/reply",
      locals: { comment: self, viewer: nil }
    )

      broadcast_replies_button(parent)
    else
      broadcast_prepend_to(
        task, :comments,
        target: "comments",
        partial: "comments/comment",
        locals: { comment: self, viewer: nil }
      )
    end
  end

  def broadcast_remove
    broadcast_remove_to(
      task,
      :comments,
      target: "comment_#{id}"
    )

    # The parent is gone too when this reply was removed along with it.
    if parent_id.present? && (remaining_parent = Comment.find_by(id: parent_id))
      broadcast_replies_button(remaining_parent)
    end
  end

  def broadcast_replies_button(parent_comment)
    broadcast_update_to(
      task, :comments,
      target: "replies-button-container-#{parent_comment.id}",
      partial: "comments/replies_button",
      locals: { comment: parent_comment }
    )
  end

  def parent_is_top_level_comment_on_same_task
    if parent.nil? || parent.task_id != task_id || parent.parent_id.present?
      errors.add(:parent, "must be a top-level comment on the same task")
    end
  end
end
