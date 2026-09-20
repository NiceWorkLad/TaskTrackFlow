class PagesController < ApplicationController
  def docs
  end

  def dev
  flash_type = params[:flash_type]
  flash_message = params[:flash_message]

  if flash_type.present? && flash_message.present?
    flash[flash_type.to_sym] = flash_message
  end
  render :dev
  end
end
