require 'rails_helper'

feature 'User updates an existing category', sign_in: true, type: :feature do
  scenario 'As a user, I should be able to update my own category' do
    category = create(:category, created_by: @current_user)
    visit edit_category_path(category.slug)

    within '#edit-category' do
      fill_in 'category_name', with: Faker::Lorem.sentence
      fill_in 'category_description', with: Faker::Lorem.paragraph
    end
    click_button 'edit-category-btn'

    expect(page).to have_content 'Your category has been updated.'
  end

  scenario 'As a user, I should not be able to update a category created by another user' do
    category = create(:category)
    visit edit_category_path(category.slug)

    expect(page).to have_content 'You are not the creator of the category'
  end
end
