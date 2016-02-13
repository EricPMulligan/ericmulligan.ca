require 'rails_helper'

feature 'Visitor visits the main page:' do
  scenario 'As a visitor, I should be able to see published posts' do
    post = create(:post, published: true)
    visit root_path
    expect(page).to have_content post.title
  end

  scenario 'As a visitor, I should be able to access the second page of posts if there are more than 10 published posts' do
    create_list(:post, 15, published: true)
    posts = Post.latest.published.paginate(page: 1, per_page: 10)
    visit root_path
    expect(page).to have_content posts[2].title
    click_link '2'
    posts = Post.latest.published.paginate(page: 2, per_page: 10)
    expect(page).to have_content posts[2].title
  end
end
