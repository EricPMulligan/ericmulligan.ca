require 'rails_helper'

feature 'User deletes an existing category', sign_in: true do
  scenario 'As a user, I should be able to delete a category that I created' do
    categories = create_list(:category, 5, created_by: @current_user)
    visit categories_path
    expect(page).to have_content categories[2].name

    click_link "delete-category-#{categories[2].id}-lnk"

    expect(page).to have_content 'The category has been deleted.'
    expect(page).not_to have_content categories[2].name
  end

  scenario 'As a user, I should not be able to delete a category created by another user' do
    categories = create_list(:category, 2)
    visit categories_path

    expect(page).to have_content categories[0].name
    expect(page).not_to have_link "delete-category-#{categories[0].id}-lnk"
  end
end