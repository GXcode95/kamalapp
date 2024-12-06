# frozen_string_literal: true

class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:id])

    if Ability.new(current_user).can?(:read, chatroom)
      stream_for chatroom
    else
      reject_subscription
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
