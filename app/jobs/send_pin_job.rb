class SendPinJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.reset_pin!
    user.unverify!
    UserMailer.with(user: user).send_pin.deliver_now
  end
end
