class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :body, presence: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies,
         class_name: "Comment",
         foreign_key: :parent_id,
         dependent: :destroy

  after_create_commit :broadcast_comment

  private

  def broadcast_comment
    if parent_id.present?
      broadcast_prepend_to(
        task, :comments,
        target: "replies-section-#{parent_id}",
        partial: "comments/reply",
        locals: { comment: self }
      )

      broadcast_replace_to(
        task, :comments,
        target: "replies-button-#{parent_id}",
        partial: "comments/replies_button",
        locals: { comment: parent }
      )
    else
      broadcast_prepend_to(
        task, :comments,
        target: "comments",
        partial: "comments/comment",
        locals: { comment: self }
      )
    end
  end
end
