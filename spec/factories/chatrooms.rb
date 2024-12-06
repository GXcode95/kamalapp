# frozen_string_literal: true

FactoryBot.define do
  factory :chatroom do
    users { [create(:user), create(:user)] }
  end
end
