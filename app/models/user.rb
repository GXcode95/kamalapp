# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chatrooms_users, dependent: :destroy
  has_many :chatrooms, through: :chatrooms_users
  has_many :messages, dependent: :destroy

end
