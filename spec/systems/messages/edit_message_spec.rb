# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit message', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:accepted_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }
  let(:chatroom) { create(:chatroom, users: [user, friend]) }
  let!(:message) { create(:message, user: user, chatroom: chatroom) }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'Edit message and validate' do
    visit chatrooms_path

    within("#chatroom_list_item_#{chatroom.id}") do
      click_link(chatroom.name)
    end

    expect(page).to have_css("#chatroom-chat [data-chatroom-id='#{chatroom.id}']")

    find("#message_#{message.id}").click_link('Edit')

    sleep 1

    within("#edit_message_#{message.id}") do
      fill_in 'message_content', with: 'Hello!', fill_options: { clear: :backspace }
      click_button('Send')
    end

    sleep 1

    expect(page).to have_css("#message_#{message.id}", text: 'Hello!')
  end

  scenario 'Edit message and cancel' do
    visit chatrooms_path

    within("#chatroom_list_item_#{chatroom.id}") do
      click_link(chatroom.name)
    end

    expect(page).to have_css("#chatroom-chat [data-chatroom-id='#{chatroom.id}']")

    find("#message_#{message.id}").click_link('Edit')

    sleep 1

    orignal_content = message.content
    within("#message_#{message.id}") do
      fill_in 'message_content', with: 'Hello!', fill_options: { clear: :backspace }
      click_link(href: chatroom_message_path(chatroom.id, message.id))
    end

    sleep 1

    expect(page).to have_css("#message_#{message.id}", text: orignal_content)
  end
end
