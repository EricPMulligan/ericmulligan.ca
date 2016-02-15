require 'rails_helper'

describe CategoriesController do
  describe 'GET #index' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when there are no categories' do
        before(:each) { get :index }

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:categories)).to be_empty }
      end

      context 'when less than 20 categories exist' do
        before(:each) do
          create_list(:post, 2, created_by: @controller.current_user)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:categories)).to match_array(Category.where(created_by: @controller.current_user).paginate(page: 1, per_page: 20).order(name: :asc)) }
      end

      context 'when more than 20 categories exist' do
        before(:each) { create_list(:post, 22, created_by: @controller.current_user) }

        context 'when accessing the first page' do
          before(:each) do
            @categories = Category.where(created_by: @controller.current_user).paginate(page: 1, per_page: 20).order(name: :asc)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:categories)).to match_array(@categories) }
        end

        context 'when accessing the second page' do
          before(:each) do
            @categories = Category.where(created_by: @controller.current_user).paginate(page: 2, per_page: 20).order(name: :asc)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:categories)).to match_array(@categories) }
        end
      end
    end

    context 'when the user is not signed in' do
      before(:each) { get :index }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'GET #new' do
    context 'when the user is signed in' do
      before(:each) do
        sign_in_as create(:user)
        get :new
      end

      it { should respond_with :ok }
      it { should render_template :new }
      it { should render_with_layout :application }
      it { expect(assigns(:category)).to be_a_new(Category) }
    end

    context 'when the user is not signed in ' do
      before(:each) { get :new }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'POST #create' do
    context 'when the user is signed in' do
      before(:each) do
        sign_in_as create(:user)
        post :create, category: { name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }
      end

      it { should respond_with :redirect }
      it { should redirect_to edit_category_path(assigns(:category)) }
      it { should set_flash[:notice].to('Your category has been created.') }
    end

    context 'when the user is not signed in' do
      before(:each) { post :create, category: { name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'GET #edit' do

  end

  describe 'PATCH #update' do

  end

  describe 'DELETE #destroy' do

  end
end