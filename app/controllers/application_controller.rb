class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery
  # before_action :redirect_if_unverified

  # def redirect_if_unverified
  #   if current_user && !current_user.email_verified?
  #     redirect_to new_verify_path, alert: "Please verify your email address to continue."
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :phone, :password, :password_confirmation, :username, :verified)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:email, :phone, :password, :password_confirmation, :username, :verified)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :phone, :password, :password_confirmation, :username, :verified)
    end
  end
end
