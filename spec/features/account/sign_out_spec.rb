# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Sign out', type: :feature do
  let(:user) { create(:user) }

  RSpec.configure do |c|
    c.include FeaturesHelper
  end

  before do
    login(user)
  end

  scenario 'signs out' do
    visit root_path
    click_link 'Sign out'

    expect(page).to have_current_path(new_user_session_path)
  end
end
