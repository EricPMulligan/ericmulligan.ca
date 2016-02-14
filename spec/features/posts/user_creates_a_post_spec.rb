require 'rails_helper'

feature 'User creates a post', sign_in: true do
  scenario 'As a user, I should be able to create a post without publishing it' do
    visit new_post_path

    within '#new-post' do
      fill_in 'new_post_title', with: Faker::Lorem.sentence
      fill_in 'new_post_body', with: Faker::Lorem.body
    end
    click_button 'new-post-save-btn'

    expect(page).to have_content 'Your post has been saved.'
  end

  scenario 'As a user, I should be able to create a post and publishing it at the same time' do
    visit new_post_path

    within '#new-post' do
      fill_in 'new_post_title', with: Faker::Lorem.sentence
      fill_in 'new_post_body', with: Faker::Lorem.body
    end
    click_button 'new-post-publish-btn'

    expect(page).to have_content 'Your post has been published.'
  end
end