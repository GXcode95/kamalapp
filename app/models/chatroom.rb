# frozen_string_literal: true

class Chatroom < ApplicationRecord
  has_many :chatrooms_users, dependent: :destroy
  has_many :users, through: :chatrooms_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  before_validation :set_name

  private

  def set_name
    self.name = [users.first.email, users.second.email].sort.join('-')
  end
end
