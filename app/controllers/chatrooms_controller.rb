# frozen_string_literal: true

class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: :show

  def index
    @chatrooms = Chatroom.all
  end

  def show
    @messages = @chatroom.messages
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
