# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chatrooms_users, dependent: :destroy
  has_many :chatrooms, through: :chatrooms_users
  has_many :messages, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :pending_friendships, -> { where(status: :pending) }, class_name: 'Friendship', dependent: :destroy, inverse_of: :user
  has_many :accepted_friendships, -> { where(status: :accepted) }, class_name: 'Friendship', dependent: :destroy, inverse_of: :user
  has_many :friends, through: :friendships

  def confirmed_friend_with?(user)
    Friendship.find_by(user: self, friend: user, status: :accepted) && Friendship.find_by(user: user, friend: self, status: :accepted)
  end

  def pending_friendships
    friendships.pending.where(friend: self)
  end

  def sent_friendships
    friendships.pending.where(user: self)
  end
end
