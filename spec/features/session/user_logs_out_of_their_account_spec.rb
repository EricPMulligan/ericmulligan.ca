require 'rails_helper'

feature 'User logs out of their account', sign_in: true do
  scenario 'As a user, I should be able to sign out of my account' do
    visit root_path
    click_link 'sign-out-lnk'
    expect(page).to have_content 'Sign In'
  end
end