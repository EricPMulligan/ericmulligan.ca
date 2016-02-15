require 'rails_helper'

feature 'User creates a new category', sign_in: true do
  scenario 'As a user, I should be able to create a new category' do
    visit new_category_path
    within '#new-category' do
      fill_in 'category_name', with: Faker::Lorem.sentence
      fill_in 'category_description', with: Faker::Lorem.paragraph
    end
    click_button 'new-category-btn'
    expect(page).to have_content 'Your category has been created.'
  end
end