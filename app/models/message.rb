# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  has_rich_text :content

  validates :content, presence: true

  broadcasts_to ->(message) { message.chatroom }, insert_by: :prepend

  after_create_commit { broadcasts_replace_to_chatrooms_list }

  private

  def broadcasts_replace_to_chatrooms_list
    chatroom.chatrooms_users.each do |chatroom_user|
      broadcast_replace_to "chatrooms_#{chatroom_user.user.id}",
                           partial: 'chatrooms/list',
                           locals: { chatrooms: chatroom_user.user.chatrooms.ordered_by_last_message.to_a,
                                     curr_user: chatroom_user.user },
                           target: 'chatrooms'
    end
  end
end
