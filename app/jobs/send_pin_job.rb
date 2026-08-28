class SendPinJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.update_columns(
      pin: rand(1000..9999),
      pin_sent_at: Time.current,
      email_verified: false
    )

    UserMailer.with(user: user).send_pin.deliver_now
  end
end
