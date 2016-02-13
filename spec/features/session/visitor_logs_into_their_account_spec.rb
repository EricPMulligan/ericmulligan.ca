require 'rails_helper'

feature 'Visitor logs into their account' do
  scenario 'As a visitor, I should be able to log into my account when I enter the right email and password combination' do
    password = Faker::Internet.password
    user = create(:user, password: password)
    create(:post, created_by: user)
    sign_in_with(user.email, password)
    expect(page).to have_content 'Sign Out'
  end

  scenario 'As a visitor, I should not be able to log into my account when I enter the wrong email and password combination' do
    sign_in_with(create(:user), Faker::Internet.password)
    expect(page).to have_content 'Bad email or password.'
  end
end
