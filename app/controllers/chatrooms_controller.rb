# frozen_string_literal: true

class ChatroomsController < ApplicationController
  load_and_authorize_resource

  def index
    @chatrooms = current_user.chatrooms
  end

  def show
    @messages = @chatroom.messages
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, user_ids: [])
  end

  def chatroom_exists?
    @chatroom = current_user.chatrooms.joins(:users).find_by(users: chatroom_params[:user_ids])
  end
end
