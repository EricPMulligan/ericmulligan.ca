require 'rails_helper'

feature 'User associates a category to a post:', sign_in: true do
  scenario 'As a user, I should be able to associate a category to a new post' do
    categories = create_list(:category, 5, created_by: @current_user)
    visit new_post_path

    within '#new-post' do
      fill_in 'post_title', with: Faker::Lorem.sentence
      fill_in 'post_body', with: Faker::Lorem.paragraph
      check "post_category_ids_#{categories[3].id}"
    end
    click_button 'new-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
    expect(page).to have_checked_field "post_category_ids_#{categories[3].id}"
  end

  scenario 'As a user, I should be able to associate a category to an already existing post' do
    categories = create_list(:category, 5, created_by: @current_user)
    post = create(:post, created_by: @current_user)
    visit edit_post_path(post.slug)

    check "post_category_ids_#{categories[1].id}"
    click_button 'edit-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
    expect(page).to have_checked_field "post_category_ids_#{categories[1].id}"
  end

  scenario 'As a user, I should be able to add another category to an existing post' do
    post = create(:post_with_categories, created_by: @current_user)
    categories = create_list(:category, 3, created_by: @current_user)
    visit edit_post_path(post.slug)

    check "post_category_ids_#{categories[2].id}"
    click_button 'edit-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
    expect(page).to have_checked_field "post_category_ids_#{categories[2].id}"
    expect(page).to have_checked_field "post_category_ids_#{post.categories.first.id}"
  end
end
