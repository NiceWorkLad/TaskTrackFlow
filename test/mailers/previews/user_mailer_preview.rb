class UserMailerPreview < ActionMailer::Preview
  def send_pin
    user = User.find_by(id: params[:user_id]) || User.first
    UserMailer.with(user: user).send_pin
  end

  def welcome_email
    user = User.find_by(id: params[:user_id]) || User.first
    UserMailer.with(user: user).welcome_email
  end
end
