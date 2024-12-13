# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum :status, {
    pending: 0,
    sent: 1,
    confirmed: 2
  }

  validate :not_self

  after_create_commit :create_reciprocal_friendship, if: -> { reciprocal_friendship.nil? }
  after_update_commit :create_chatroom,
                      if: -> { saved_change_to_status? && confirmed? && !Chatroom.with_users([user.id, friend.id]) }
  after_update_commit :update_reciprocal_friendship, if: :saved_change_to_status
  after_destroy :destroy_reciprocal_friendship, unless: -> { reciprocal_friendship.nil? }

  def reciprocal_friendship
    Friendship.find_by(user: friend, friend: user)
  end

  private

  def not_self
    errors.add(:friend, 'can\'t be friend with yourself') if user == friend
  end

  def create_reciprocal_friendship
    Friendship.create!(user: friend, friend: user, status: :pending)
  end

  def destroy_reciprocal_friendship
    reciprocal_friendship&.destroy
  end

  def create_chatroom
    Chatroom.create!(user_ids: [user.id, friend.id])
  end

  def update_reciprocal_friendship
    reciprocal_friendship.update(status: :confirmed) if confirmed? && reciprocal_friendship.sent?
  end
end
