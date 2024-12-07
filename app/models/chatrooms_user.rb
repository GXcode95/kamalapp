# frozen_string_literal: true

class ChatroomsUser < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :user_id, uniqueness: { scope: :chatroom_id }

  after_create_commit :update_last_visit_at

  def update_last_visit_at
    update_column(:last_visit_at, Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
  end

  def unread_messages?
    messages = chatroom.messages.where.not(user: user)
    return false if messages.empty?

    last_message = messages.order(updated_at: :desc).first
    last_message && last_message.created_at > last_visit_at
  end
end
