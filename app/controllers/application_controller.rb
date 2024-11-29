# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  add_flash_types :success, :errorn, :warning
  before_action :authenticate_user!

  def authenticate_user!
    redirect_to new_user_session_path unless user_signed_in? || devise_controller?
  end
end
