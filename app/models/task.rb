class Task < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy

  scope :search, ->(query) {
    if query.present?
      where("title LIKE ? OR description LIKE ? OR body LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    end
  }

  before_create :generate_uuid

  private

  def generate_uuid
    self.id = SecureRandom.uuid
  end
end
