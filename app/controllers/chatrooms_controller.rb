# frozen_string_literal: true

class ChatroomsController < ApplicationController
  load_and_authorize_resource

  def index
    @chatrooms = current_user.chatrooms.ordered_by_last_message
    @chatroom = @chatrooms.first
    @chatroom.chatrooms_users.find_by(user: current_user).update(last_visit_at: Time.zone.now) if @chatroom
  end

  def show
    @chatroom.chatrooms_users.find_by(user: current_user).update(last_visit_at: Time.zone.now)
    @messages = @chatroom.messages
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, user_ids: [])
  end
end
