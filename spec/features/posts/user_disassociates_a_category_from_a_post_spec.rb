require 'rails_helper'

feature 'User disassociates a category from a post', sign_in: true do
  scenario 'As a user, I want to disassociate a category from a post' do
    post = create(:post_with_categories, created_by: @current_user)
    visit edit_post_path(post.slug)

    expect(page).to have_checked_field "post_category_ids_#{post.categories[1].id}"

    uncheck "post_category_ids_#{post.categories[1].id}"
    click_button 'edit-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
    expect(page).not_to have_checked_field "post_category_ids_#{post.categories[1].id}"
  end
end
