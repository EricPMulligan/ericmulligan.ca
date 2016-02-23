require 'rails_helper'

feature 'User edits a post', sign_in: true do
  scenario 'As a user, I should be able to edit a published post' do
    post = create(:post, published: true, created_by: @current_user)
    visit edit_post_path(post.slug)

    within '#edit-post' do
      fill_in 'post_title', with: Faker::Lorem.sentence
      fill_in 'post_body', with: Faker::Lorem.paragraph
    end
    click_button 'edit-post-update-btn'

    expect(page).to have_content 'Your post has been saved.'
  end

  scenario 'As a user, I should be able to edit a non-published post' do
    post = create(:post, published: false, created_by: @current_user)
    visit edit_post_path(post.slug)

    within '#edit-post' do
      fill_in 'post_title', with: Faker::Lorem.sentence
      fill_in 'post_body', with: Faker::Lorem.paragraph
    end
    click_button 'edit-post-update-btn'

    expect(page).to have_content 'Your post has been saved.'
  end

  scenario 'As a user, I should be able to publish a non-published post' do
    post = create(:post, published: false, created_by: @current_user)
    visit edit_post_path(post.slug)

    within '#edit-post' do
      fill_in 'post_title', with: Faker::Lorem.sentence
      fill_in 'post_body', with: Faker::Lorem.paragraph
    end
    click_button 'edit-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
  end
end
