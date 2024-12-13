# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accept friendship', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:accepted_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'User accept a friend request from users page' do
    expect(user_friendship.pending?).to eq(true)

    visit users_path
    find("#user_#{friend.id}").click_link('Accept')

    sleep 1

    expect(user_friendship.reload.accepted?).to eq(true)

    expect(page).to have_selector("#user_#{friend.id} a", text: 'Unfriend')

    expect(page).to have_selector("#user_#{friend.id} button", text: 'Send message')
  end

  scenario 'User accept a friend request from friendships page' do
    expect(user_friendship.pending?).to eq(true)

    visit friendships_path
    find("#user_#{friend.id}").click_link('Accept')

    sleep 1

    expect(user_friendship.reload.accepted?).to eq(true)

    expect(page).to have_selector("#user_#{friend.id} a", text: 'Unfriend')

    expect(page).to have_selector("#user_#{friend.id} button", text: 'Send message')
  end
end
