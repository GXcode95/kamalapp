# frozen_string_literal: true

FactoryBot.define do
  factory :pending_friendship, class: Friendship do
    user { create(:user) }
    friend { create(:user) }
    status { :accepted }
  end

  factory :accepted_friendship, class: Friendship do
    user { create(:user) }
    friend { create(:user) }
    status { :accepted }

    after(:create) do |friendship|
      reciprocal_friendship = Friendship.find_by(user: friendship.friend, friend: friendship.user)
      reciprocal_friendship.update!(status: :accepted) if reciprocal_friendship.present?
    end
  end
end
