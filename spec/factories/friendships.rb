# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association :user
    association :friend, factory: :user
    status { :confirmed }
  end

  factory :confirmed_friendship, parent: :friendship do
    status { :confirmed }
  end

  factory :pending_friendship, parent: :friendship do
    status { :pending }
  end

  factory :sent_friendship, parent: :friendship do
    status { :sent }
  end
end
