# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Send message', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:confirmed_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }
  let(:chatroom) { create(:chatroom, users: [user, friend]) }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'User sends a message in a chatroom' do
    visit chatrooms_path

    within("#chatroom_list_item_#{chatroom.id}") do
      click_link(chatroom.name)
    end

    expect(page).to have_css("#chatroom-chat [data-chatroom-id='#{chatroom.id}']")

    within('#new_message') do
      fill_in 'message_content', with: 'Hello!'

      find('input[type="submit"]').click
    end

    expect(page).to have_css('.message', text: 'Hello!', wait: 10)

    expect(page).to have_selector('#new_message textarea', text: '')
  end
end
