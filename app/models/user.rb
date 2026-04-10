class User < ApplicationRecord
  attr_accessor :pin_0, :pin_1, :pin_2, :pin_3

  has_many :tasks, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :send_pin!

  def send_pin!
    SendPinJob.perform_later(id)
  end

  def reset_pin!
    update_columns(pin: rand(1000..9999), pin_sent_at: Time.current)
  end

  def unverify!
    update_column(:email_verified, false)
  end
end
