class User < ApplicationRecord
  attr_accessor :pin_0, :pin_1, :pin_2, :pin_3

  has_many :tasks, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :send_welcome_email!

  private

  def send_welcome_email!
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  def send_pin!
    SendPinJob.perform_later(id)
  end

  public

  def deliver_pin!
    send_pin!
  end
end
