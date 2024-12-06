# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # === Chatroom ===

    can :read, Chatroom, users: { id: user.id }

    # === Message ===

    can :read, Message, chatroom: { chatrooms_users: { user_id: user.id } }

    can :create, Message do |message|
      message.chatroom.users.include?(user) && message.user == user
    end

    can %i[update destroy], Message, user: user

    # === Friendship ===

    can :manage, Friendship, user: user
  end
end
