require 'rails_helper'

feature 'Visitor views about me page' do
  scenario 'As a user, I should be able to view the about me page' do
    visit about_path
    expect(page).to have_content 'About Me'
  end
end
