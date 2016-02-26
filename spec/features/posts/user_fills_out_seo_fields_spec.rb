require 'rails_helper'

feature 'User fills out SEO fields:', sign_in: true do
  scenario 'As a user, I should be able to fill out the SEO fields on a new post' do
    visit new_post_path

    title           = Faker::Lorem.sentence
    body            = Faker::Lorem.paragraph
    seo_title       = Faker::Lorem.sentence
    seo_description = Faker::Lorem.sentence

    within '#new-post' do
      fill_in 'post_title', with: title
      fill_in 'post_body', with: body
      fill_in 'post_seo_title', with: seo_title
      fill_in 'post_seo_description', with: seo_description
    end
    click_button 'new-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
    expect(page).to have_field 'post_title', with: title
    expect(page).to have_field 'post_body', with: body
    expect(page).to have_field 'post_seo_title', with: seo_title
    expect(page).to have_field 'post_seo_description', with: seo_description
  end

  scenario 'As a user, I should be able to fill out the SEO fields on an existing post' do
    post = create(:post, created_by: @current_user)
    visit edit_post_path(post.slug)

    seo_title       = Faker::Lorem.sentence
    seo_description = Faker::Lorem.sentence

    within '#edit-post' do
      fill_in 'post_seo_title', with: seo_title
      fill_in 'post_seo_description', with: seo_description
    end
    click_button 'edit-post-update-btn'

    expect(page).to have_content 'Your post has been saved.'
    expect(page).to have_field 'post_seo_title', with: seo_title
    expect(page).to have_field 'post_seo_description', with: seo_description
  end
end