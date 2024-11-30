class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # Abonne l'utilisateur à un flux spécifique à la chatroom
    chatroom = Chatroom.find(params[:id])
    stream_for chatroom
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
