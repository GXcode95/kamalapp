# frozen_string_literal: true

module FeaturesHelper
  def login(user)
    visit '/users/sign_in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Sign in'
  end
end
