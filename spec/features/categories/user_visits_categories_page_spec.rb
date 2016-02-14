require 'rails_helper'

feature 'User visits categories page', sign_in: true do
  scenario 'As a user, I should be able to see all of the categories that I have created' do
    categories = create_list(:category, 5, created_by: @current_user)
    visit categories_path
    expect(page).to have_content categories[2].name
  end

  scenario 'As a user, I should be able to see paginated view of 22 categories where there are 20 categories per page' do
    create_list(:category, 22, created_by: @current_user)
    categories = Category.where(created_by: @current_user).paginate(page: 1, per_page: 20).order(name: :asc)
    visit categories_path
    expect(page).to have_content categories[11].name
    click_link '2'
    categories = Category.where(created_by: @current_user).paginate(page: 2, per_page: 20).order(name: :asc)
    expect(page).to have_content categories[1].name
  end
end