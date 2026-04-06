class SendPinJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user.reset_pin!
    user.update(pin__sent_at: Time.current)
    UserMailer.send_pin(user).deliver_now
  end
end
