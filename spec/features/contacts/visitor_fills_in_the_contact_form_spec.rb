require 'rails_helper'

feature 'Visitor fills in the contact form' do
  before { ActionMailer::Base.deliveries.clear }

  scenario 'As a visitor, I want to fill in the contact form in order to send an email to Eric Mulligan', performed_enqueued: true do
    visit contact_path

    within '#new-contact' do
      fill_in 'contact_name', with: Faker::Internet.name
      fill_in 'contact_email', with: Faker::Internet.email
      fill_in 'contact_body', with: Faker::Lorem.paragraph
    end
    perform_enqueued_jobs do
      click_button 'new-contact-btn'
    end

    expect(page).to have_content 'Your message has been sent to Eric Mulligan.'
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end
end
