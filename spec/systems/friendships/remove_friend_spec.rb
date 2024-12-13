# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Remove friend', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:confirmed_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
    user_friendship.update(status: :confirmed)
  end

  scenario 'User remove a friend from friendships page' do
    visit friendships_path
    find("#user_#{friend.id}").click_link('Unfriend')

    sleep 1

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect { friend_friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(page).to have_no_selector("#user_#{friend.id}")
  end
end
