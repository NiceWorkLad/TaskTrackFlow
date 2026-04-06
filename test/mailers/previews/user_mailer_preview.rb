class UserMailerPreview < ActionMailer::Preview
  def send_pin
    user = User.first
    UserMailer.with(user:).send_pin
  end

  def welcome_email
    user = User.first
    UserMailer.with(user:).welcome_email
  end
end
