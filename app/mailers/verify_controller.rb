class VerifyController < ApplicationController
  skip_before_action :redirect_if_unverified
  def new
    @user = current_user
  end

  def create
    current_user.send_pin!
    redirect_to new_verify_path, notice: "A new PIN has been sent to your email address."
  end

  def edit
    @user = current_user
  end

  def update
    code = "#{params[:user][:pin_0]}#{params[:user][:pin_1]}#{params[:user][:pin_2]}#{params[:user][:pin_3]}"
    @user = current_user

    if current_user.pin_sent_at.blank? || Time.current > current_user.pin_sent_at.advance(minutes: 99990)
      flash.now[:alert] = "Your PIN has expired. Please request another."
      render :new and return
    elsif code.try(:to_i) == current_user.pin
      current_user.update_attribute(:email_verified, true)
      redirect_to root_url, notice: "Your email address has been verified!"
    else
      flash.now[:alert] = "The code you entered is invalid."
      render :edit
    end
  end
end
