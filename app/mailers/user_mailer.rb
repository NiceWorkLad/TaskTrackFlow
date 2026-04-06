class UserMailer < ApplicationMailer
  def send_pin
    @user = params[:user]
    mail(to: @user.email, subject: 'Verification PIN Code')
  end

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to TaskTracker!')
  end
end
