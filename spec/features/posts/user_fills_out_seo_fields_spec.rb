require 'rails_helper'

feature 'User fills out SEO fields:', sign_in: true do
  scenario 'As a user, I should be able to fill out the SEO fields' do
    visit new_post_path

    within '#new-post' do
      fill_in 'post_title', with: Faker::Lorem.sentence
      fill_in 'post_body', with: Faker::Lorem.paragraph
      fill_in 'post_seo_title', with: Faker::Lorem.sentence
      fill_in 'post_seo_description', with: Faker::Lorem.sentence
      fill_in 'post_og_type', with: 'website'
      fill_in 'post_twitter_card', with: 'website'

    end
  end
end