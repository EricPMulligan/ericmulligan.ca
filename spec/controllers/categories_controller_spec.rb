require 'rails_helper'

describe CategoriesController do
  describe 'GET #index' do
    context 'when there are no categories' do
      before(:each) { get :index }

      it { should respond_with :ok }
      it { should render_template :index }
      it { should render_with_layout :application }
      it { expect(assigns(:categories)).to be_empty }
    end

    context 'when less than 20 categories exist' do
      before(:each) do
        create_list(:post, 2)
        get :index
      end

      it { should respond_with :ok }
      it { should render_template :index }
      it { should render_with_layout :application }
      it { expect(assigns(:categories)).to match_array(Category.paginate(page: 1, per_page: 20).order(name: :asc)) }
    end

    context 'when more than 20 categories exist' do
      before(:each) { create_list(:post, 22) }

      context 'when accessing the first page' do
        before(:each) do
          @categories = Category.paginate(page: 1, per_page: 20).order(name: :asc)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:categories)).to match_array(@categories) }
      end

      context 'when accessing the second page' do
        before(:each) do
          @categories = Category.paginate(page: 2, per_page: 20).order(name: :asc)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:categories)).to match_array(@categories) }
      end
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

  describe 'GET #show' do
    context 'when the category exists' do
      before(:each) do
        @category = create(:category)
        get :show, id: @category.id
      end

      it { should respond_with :ok }
      it { should render_template :show }
      it { should render_with_layout :application }
      it { expect(assigns(:category)).to eq(@category) }
    end

    context 'when the category does not exist' do
      before(:each) { get :show, id: 9898398 }

      it { should respond_with :redirect }
      it { should redirect_to categories_path }
      it { should set_flash[:alert].to('The category you are looking for does not exist.') }
    end
  end

  describe 'GET #edit' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the category exists' do
        context 'when the user is the creator of the category' do
          before(:each) do
            @category = create(:category, created_by: @controller.current_user)
            get :edit, id: @category.id
          end

          it { should respond_with :ok }
          it { should render_template :edit }
          it { should render_with_layout :application }
          it { expect(assigns(:category)).to eq(@category) }
        end

        context 'when the user is not the creator of the category' do
          before(:each) { get :edit, id: create(:category).id }

          it { should respond_with :redirect }
          it { should redirect_to categories_path }
          it { should set_flash[:alert].to('You are not the creator of the category.') }
        end
      end

      context 'when the category does not exist' do
        before(:each) { get :edit, id: 9898398 }

        it { should respond_with :redirect }
        it { should redirect_to categories_path }
        it { should set_flash[:alert].to('The category you are looking for does not exist.') }
      end
    end

    context 'when the user is not signed in' do
      before(:each) { get :edit, id: create(:category) }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'PATCH #update' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the category exists' do
        context 'when the user is the creator of the category' do
          context 'setting the name to blank' do
            before(:each) do
              @category              = create(:category, created_by: @controller.current_user)
              category_params        = @category.attributes
              category_params[:name] = ''
              patch :update, category: category_params, id: @category.id
            end

            it { should respond_with :ok }
            it { should render_template :edit }
            it { should render_with_layout :application }
            it { expect(assigns(:category)).to eq(@category) }
          end

          context 'setting the name' do
            before(:each) do
              @category = create(:category, created_by: @controller.current_user)
              @category.name = Faker::Lorem.sentence
              patch :update, category: @category.attributes, id: @category.id
            end

            it { should respond_with :redirect }
            it { should redirect_to edit_category_path(@category) }
            it { should set_flash[:notice].to('Your category has been updated.') }
          end
        end

        context 'when the user is not the creator of the category' do
          before(:each) do
            category = create(:category)
            patch :update, category: category.attributes, id: category.id
          end

          it { should respond_with :redirect }
          it { should redirect_to categories_path }
          it { should set_flash[:alert].to('You are not the creator of the category.') }
        end
      end

      context 'when the category does not exist' do
        before(:each) { patch :update, category: attributes_for(:category), id: 39898938 }

        it { should respond_with :redirect }
        it { should redirect_to categories_path }
        it { should set_flash[:alert].to('The category you are looking for does not exist.') }
      end
    end

    context 'when the user is not signed in' do
      before(:each) do
        category = create(:category)
        patch :update, category: category.attributes, id: category.id
      end

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the category exists' do
        context 'when the user is the creator of the category' do
          before(:each) do
            category = create(:category, created_by: @controller.current_user)
            delete :destroy, id: category.id
          end

          it { should respond_with :redirect }
          it { should redirect_to categories_path }
          it { should set_flash[:notice].to('The category has been deleted.') }
        end

        context 'when the user is not the creator of the category' do
          before(:each) { delete :destroy, id: create(:category).id }

          it { should respond_with :redirect }
          it { should redirect_to categories_path }
          it { should set_flash[:alert].to('You are not the creator of the category.') }
        end
      end

      context 'when the category does not exist' do
        before(:each) { delete :destroy, id: 9898398983 }

        it { should respond_with :redirect }
        it { should redirect_to categories_path }
        it { should set_flash[:alert].to('The category you are looking for does not exist.') }
      end
    end

    context 'when the user is not signed in' do
      before(:each) { delete :destroy, id: create(:category).id }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'GET #coding' do
    context 'when the category exists' do
      before(:each) do
        @category = create(:category, name: 'Coding')
        get :coding
      end

      it { should respond_with :ok }
      it { should render_template :coding }
      it { should render_with_layout :application }
      it { expect(assigns(:category)).to eq(@category) }
    end

    context 'when the category does not exist' do
      before(:each) { get :coding }

      it { should respond_with :redirect }
      it { should redirect_to root_path }
      it { should set_flash[:alert].to('The category you are looking for does not exist.') }
    end
  end
end