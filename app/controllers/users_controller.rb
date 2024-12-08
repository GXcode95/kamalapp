# frozen_string_literal: true

class UsersController < ApplicationController
  include HasScope

  before_action :authenticate_user!

  has_scope :by_email

  def index
    @users = apply_scopes(User).where.not(id: current_user)
  end
end
