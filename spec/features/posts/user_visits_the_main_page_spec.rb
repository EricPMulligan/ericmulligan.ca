require 'rails_helper'

feature 'User visits the main page', sign_in: true do
  scenario 'As a user, I should be able to see published posts' do
    post = create(:post, published: true)

    visit root_path
    expect(page).to have_content post.title
  end

  scenario 'As a user, I should be able to see unpublished posts where I am the one who created them' do
    post               = create(:post, published: true)
    unpublished_post_1 = create(:post, created_by: @current_user)
    unpublished_post_2 = create(:post)

    visit root_path
    expect(page).to have_content post.title
    expect(page).to have_content unpublished_post_1.title
    expect(page).not_to have_content unpublished_post_2.title
  end
end