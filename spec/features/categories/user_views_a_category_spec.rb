require 'rails_helper'

feature 'User views a category', sign_in: true do
  scenario 'As a user, I should be able to view one of my categories' do
    category = create(:category, created_by: @current_user)
    visit category_path(category)

    expect(page).to have_content category.name
    expect(page).to have_content category.description
  end

  scenario 'As a user, I should be able to see all categories' do
    category = create(:category)
    visit category_path(category)

    expect(page).to have_content category.name
    expect(page).to have_content category.description
  end
end
