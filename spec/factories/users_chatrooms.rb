# frozen_string_literal: true

FactoryBot.define do
  factory :users_room do
    user              { create(:user) }
    room              { create(:room) }
  end
end
