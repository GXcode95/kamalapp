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
  has_many :sent_friendships, -> { where(status: :sent) }, class_name: 'Friendship', dependent: :destroy, inverse_of: :user
  has_many :confirmed_friendships, -> { where(status: :confirmed) }, class_name: 'Friendship', dependent: :destroy, inverse_of: :user
  has_many :friends, through: :friendships

  scope :by_email, ->(email) { email.present? ? where('email LIKE ?', "%#{email}%") : none }
end
