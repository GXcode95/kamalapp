# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association :user
    association :friend, factory: :user
    status { :accepted }
  end

  factory :accepted_friendship, parent: :friendship do
    status { :accepted }
  end

  factory :pending_friendship, parent: :friendship do
    status { :accepted }
  end
end
