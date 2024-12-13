# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy message', type: :system do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friend_friendship) { create(:confirmed_friendship, user: friend, friend: user) }
  let(:user_friendship) { friend_friendship.reciprocal_friendship }
  let(:chatroom) { create(:chatroom, users: [user, friend]) }
  let!(:message) { create(:message, user: user, chatroom: chatroom) }

  before do
    Capybara.default_driver = :selenium_chrome_headless
    login_as(user, scope: :user)
  end

  scenario 'Destroy message and validate' do
    visit chatrooms_path

    within("#chatroom_list_item_#{chatroom.id}") do
      click_link(chatroom.name)
    end

    expect(page).to have_css("#chatroom-chat [data-chatroom-id='#{chatroom.id}']")

    find("#message_#{message.id}").click_button('Delete')
    alert = page.driver.browser.switch_to.alert

    expect(alert.text).to eq('Are you sure?')

    alert.accept

    sleep 1

    expect(page).to have_no_selector("#message_#{message.id}")
  end
end
