require 'rails_helper'

feature 'User unpublishes a post', sign_in: true do
  scenario 'As a user, I should be able to unpublish my own post' do
    post = create(:published_post, created_by: @current_user)
    visit edit_post_path(post.slug)

    expect(page).to have_button 'edit-post-unpublish-btn'
    click_button 'edit-post-unpublish-btn'
    expect(page).to have_content 'Your post has been unpublished.'
  end
end