class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.where.not(id: current_user)
  end
end
