# frozen_string_literal: true

class UsersController < ApplicationController
  include HasScope

  before_action :authenticate_user!

  def index
    @users = User.by_email(params[:by_email]).where.not(id: current_user.id)
  end
end
