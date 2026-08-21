class SettingsController < ApplicationController
  before_action :authenticate_user!

  def update_username
    if current_user.update(username_params)
      redirect_to pages_profile_path, notice: "Username upated successfully."
    else
      redirect_to pages_profile_path, alert: current_user.errors.full_messages.to_sentence
    end
  end

  private

  def username_params
    params.require(:user).permit(:username)
  end
end
