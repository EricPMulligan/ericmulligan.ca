require 'rails_helper'

describe ContactController do
  describe 'GET #index' do
    before(:each) { get :index }

    it { should respond_with :ok }
    it { should render_template :index }
    it { should render_with_layout :application }
    it { expect(assigns(:contact)).to be_a_new(Contact) }
  end

  describe 'POST #create' do
    context 'when the user fills out all required fields' do
      before(:each) { post :create, params: { contact: { name: Faker::Internet.name, email: Faker::Internet.email, body: Faker::Lorem.paragraph } } }

      it { should respond_with :redirect }
      it { should redirect_to contact_path }
      it { should set_flash[:notice].to('Your message has been sent to Eric Mulligan.') }
    end

    context 'when the user does not fill out all the required fields' do
      context 'when the email is missing' do
        before(:each) { post :create, params: { contact: { name: Faker::Internet.name, email: '', body: Faker::Lorem.paragraph } } }

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { should set_flash.now[:alert].to(["<li>Email can't be blank</li>"]) }
      end

      context 'when the body is missing' do
        before(:each) { post :create, params: { contact: { name: Faker::Internet.name, email: Faker::Internet.email, body: '' } } }

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { should set_flash.now[:alert].to(["<li>Body can't be blank</li>"]) }
      end
    end
  end
end
