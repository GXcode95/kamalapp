# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Add friend', type: :system do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'User adds a friend' do
    visit friendships_path

    within '#users' do
      fill_in 'by_email', with: friend.email
      find_field('by_email').send_keys(:enter)
    end

    sleep 1

    find("#user_#{friend.id}").click_button('Invite')

    sleep 1

    expect(
      user.friendships.find_by(friend_id: friend.id, status: :sent)
    ).to be_truthy

    expect(
      friend.friendships.find_by(friend_id: user.id, status: :pending)
    ).to be_truthy

    expect(page).to have_selector("#user_#{friend.id} a", text: 'Unfriend')
  end
end
