class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  has_rich_text :content

  validates :content, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
    ChatroomChannel.broadcast_to(
      chatroom,
      message: render_message(self)
    )
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
