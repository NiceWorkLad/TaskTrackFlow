class User < ApplicationRecord
  attr_accessor :pin_0, :pin_1, :pin_2, :pin_3

  has_many :tasks, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 after_create :update_user_verified_column_to_true
 after_create :send_pin!

  private
  def update_user_verified_column_to_true
    UpdateUserJob.perform_later(self)
  end

  def reset_pin!
    update_columns(pin: rand(1000..9999), pin_sent_at: Time.current)
  end

  def unverify!
    update_column(:email_verified, false)
  end

  def send_pin!
    reset_pin!
    unverify!
    SendPinJob.perform_later(self)
  end

  public

  def deliver_pin!
    send_pin!
  end
end
