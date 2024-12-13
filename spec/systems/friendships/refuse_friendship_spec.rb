# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Refuse friendship', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:accepted_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'User refuse a friend request from user page' do
    expect(user_friendship.pending?).to eq(true)

    visit users_path
    find("#user_#{friend.id}").click_link('Decline')

    sleep 1

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(page).to have_selector("#user_#{friend.id} button", text: 'Invite')
  end

  scenario 'User refuse a friend request from friendships page' do
    expect(user_friendship.pending?).to eq(true)

    visit friendships_path
    find("#user_#{friend.id}").click_link('Decline')

    sleep 1

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(page).to have_no_selector("#user_#{friend.id}")
  end
end
