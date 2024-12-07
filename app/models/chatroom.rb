# frozen_string_literal: true

class Chatroom < ApplicationRecord
  has_many :chatrooms_users, dependent: :destroy
  has_many :users, through: :chatrooms_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  before_validation :set_name

  scope :with_exact_user_ids, lambda { |user_ids|
    joins(:chatrooms_users)
      .where(chatrooms_users: { user_id: user_ids })
      .group('chatrooms.id')
      .having('COUNT(chatrooms_users.user_id) = ?', user_ids.size)
  }

  scope :ordered_by_last_message, -> { left_joins(:messages).group('chatrooms.id').order('MAX(messages.created_at) DESC') }




  def self.with_users(users)
    users.map do |user|
      user.instance_of?(User) ? user.id : user
    end

    with_exact_user_ids(users)&.first
  end

  private

  def set_name
    self.name = [users.first.email, users.second.email].sort.join('-')
  end
end
