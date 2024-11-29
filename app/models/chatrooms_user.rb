# frozen_string_literal: true

class ChatroomsUser < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :user_id, uniqueness: { scope: :chatroom_id }
end
