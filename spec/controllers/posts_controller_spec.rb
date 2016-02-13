require 'rails_helper'

describe PostsController do
  describe 'GET #index' do
    context 'when under 10 posts exists' do
      before(:each) do
        create_list(:post, 7, published: true)
        @posts = Post.latest.published.paginate(page: 1, per_page: 10)
        get :index
      end

      it { should respond_with :ok }
      it { should render_template :index }
      it { should render_with_layout :application }
      it { expect(assigns(:posts)).to match @posts }
    end

    context 'when over 10 posts exists' do
      before(:each) { create_list(:post, 15, published: true) }

      context 'when accessing the first page' do
        before(:each) do
          @posts = Post.latest.published.paginate(page: 1, per_page: 10)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to match @posts }
      end

      context 'when accessing the second page' do
        before(:each) do
          @posts = Post.latest.published.paginate(page: 2, per_page: 10)
          get :index, page: 2
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to match @posts }
      end
    end

    context 'when no posts exist' do
      context 'that are published' do
        context 'not signed in' do
          before(:each) do
            create_list(:post, 5, published: false)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to be_empty }
        end

        context 'when signed in' do
          before(:each) { sign_in_as create(:user) }

          context 'when I created the unpublished post' do
            before(:each) do
              @post = create(:post, published: false, created_by: @controller.current_user)
              get :index
            end

            it { should respond_with :ok }
            it { should render_template :index }
            it { should render_with_layout :application }
            it { expect(assigns(:posts)).to include @post }
          end
        end
      end

      context "that aren't published" do
        before(:each) { get :index }

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to be_empty }
      end
    end
  end

  describe 'GET #show' do
    context 'when the post exists' do
      context 'when the post is published' do
        before(:each) do
          @post = create(:post, published: true)
          get :show, slug: @post.slug
        end

        it { should respond_with :ok }
        it { should render_template :show }
        it { should render_with_layout :application }
        it { expect(assigns(:post)).to eq(@post) }
      end

      context 'when the post has not yet been published' do
        context 'when the user is signed in' do
          before(:each) do
            @user = create(:user)
            sign_in_as(@user)
          end

          context 'when the user is the author of the post' do
            before(:each) do
              @post = create(:post, published: false, created_by: @user)
              get :show, slug: @post.slug
            end

            it { should respond_with :ok }
            it { should render_template :show }
            it { should render_with_layout :application }
            it { expect(assigns(:post)).to eq(@post) }
          end

          context 'when the user is not the author of the post' do
            before(:each) do
              post = create(:post, published: false)
              get :show, slug: post.slug
            end

            it { should respond_with :redirect }
            it { should redirect_to root_path }
            it { should set_flash[:alert].to('You are not the author of the unpublished post.') }
          end
        end

        context 'when the user is not signed in' do
          before(:each) do
            post = create(:post, published: false)
            get :show, slug: post.slug
          end

          it { should respond_with :redirect }
          it { should redirect_to root_path }
          it { should set_flash[:alert].to('You must be signed in to view the unpublished post.') }
        end
      end
    end

    context 'when the post does not exist' do
      before(:each) { get :show, slug: 'blah' }

      it { should respond_with :redirect }
      it { should redirect_to root_path }
      it { should set_flash[:alert].to('The post you are looking for does not exist.') }
    end
  end
end
