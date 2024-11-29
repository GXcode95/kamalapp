# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  has_rich_text :content

  validates :content, presence: true

  broadcasts_to ->(message) { message.chatroom }, insert_by: :preprend
end
