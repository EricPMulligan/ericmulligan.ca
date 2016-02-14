require 'rails_helper'

feature 'User deletes their post', sign_in: true do
  scenario 'As a user, I should be able to delete a post that I have published' do
    post = create(:post, published: true, created_by: @current_user)
    visit root_path

    expect(page).to have_content post.title

    click_link "delete-post-#{post.id}-lnk"
    expect(page).to have_content 'Your post has been deleted.'
    expect(page).not_to have_content post.title
  end

  scenario 'As a user, I should be able to delete a post that I have saved' do
    post = create(:post, published: false, created_by: @current_user)
    visit root_path

    expect(page).to have_content post.title

    click_link "delete-post-#{post.id}-lnk"
    expect(page).to have_content 'Your post has been deleted.'
    expect(page).not_to have_content post.title
  end
end