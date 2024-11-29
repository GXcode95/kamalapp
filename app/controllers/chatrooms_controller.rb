# frozen_string_literal: true

class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: %i[show]

  def index
    @chatrooms = Chatroom.all
  end

  def show
    @messages = @chatroom.messages
  end

  def create
    redirect_to @chatroom and return if chatroom_exists?

    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.users << current_user

    if @chatroom.save
      flash[:success] = I18n.t('flash.actions.create.success', resource_name: Chatroom.model_name.human)
      redirect_to @chatroom
    else
      flash[:error] = I18n.t('flash.actions.create.error', resource_name: Chatroom.model_name.human)
      redirect_to users_path
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def chatroom_params
    params.require(:chatroom).permit(:name, user_ids: [])
  end

  def chatroom_exists?
    @chatroom = current_user.chatrooms.joins(:users).find_by(users: chatroom_params[:user_ids])
  end
end
