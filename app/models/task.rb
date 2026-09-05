class Task < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy

  scope :search, ->(query) {
    if query.present?
      where("title LIKE ? OR description LIKE ? OR body LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    end
  }
end
