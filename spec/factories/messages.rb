# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    chatroom      { create(:chatroom) }
    user          { create(:user) }
    content       { Faker::Lorem.sentence }
  end
end
