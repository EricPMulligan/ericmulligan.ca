module EricMulliganBlog
  module Features
    def sign_in_with(email, password)
      visit sign_in_path
      within '#sign-in' do
        fill_in 'session_email', with: email
        fill_in 'session_password', with: password
      end
      click_button 'sign-in-btn'
    end
  end
end

RSpec.configure do |config|
  config.include EricMulliganBlog::Features, type: :feature

  config.before(:each, sign_in: true, type: :feature) do
    password = Faker::Internet.password
    @current_user = create(:user, password: password)
    sign_in_with(@current_user.email, password)
  end
end
