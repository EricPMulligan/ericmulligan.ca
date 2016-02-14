require 'rails_helper'

describe PostsController do
  describe 'GET #index' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when under 10 published posts exists' do
        before(:each) do
          create_list(:post, 7, published: true)
          @posts = Post.latest.published.paginate(page: 1, per_page: 10)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to match_array @posts }
      end

      context 'when over 10 published posts exists' do
        before(:each) { create_list(:post, 15, published: true) }

        context 'when accessing the first page' do
          before(:each) do
            @posts = Post.latest.published.paginate(page: 1, per_page: 10)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to match_array @posts }
        end

        context 'when accessing the second page' do
          before(:each) do
            @posts = Post.latest.published.paginate(page: 2, per_page: 10)
            get :index, page: 2
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to match_array @posts }
        end
      end

      context 'when there are no published posts that exist' do
        before(:each) { get :index }

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to be_empty }
      end

      context 'when unpublished posts exist' do
        context 'when they were created by another user' do
          before(:each) do
            create_list(:post, 2, published: false)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to be_empty }
        end

        context 'when they were created by the same user' do
          before(:each) do
            @posts = create_list(:post, 2, published: false, created_by: @controller.current_user)
            get :index
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to match_array @posts }
        end
      end
    end

    context 'when the user is not signed in' do
      context 'when under 10 posts exists' do
        before(:each) do
          create_list(:post, 7, published: true)
          @posts = Post.latest.published.paginate(page: 1, per_page: 10)
          get :index
        end

        it { should respond_with :ok }
        it { should render_template :index }
        it { should render_with_layout :application }
        it { expect(assigns(:posts)).to match_array @posts }
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
          it { expect(assigns(:posts)).to match_array @posts }
        end

        context 'when accessing the second page' do
          before(:each) do
            @posts = Post.latest.published.paginate(page: 2, per_page: 10)
            get :index, page: 2
          end

          it { should respond_with :ok }
          it { should render_template :index }
          it { should render_with_layout :application }
          it { expect(assigns(:posts)).to match_array @posts }
        end
      end

      context 'when there are no posts that exist' do
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

  describe 'GET #new' do
    context 'when the user is signed in' do
      before(:each) do
        sign_in_as create(:user)
        get :new
      end

      it { should respond_with :ok }
      it { should render_template :new }
      it { should render_with_layout :application }
      it { expect(assigns(:post)).to be_a_new(Post) }
    end

    context 'when the user is not signed in' do
      before(:each) { get :new }

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to 'Please sign in to continue.' }
    end
  end

  describe 'POST #create' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the user attempts to publish the post' do
        context 'when not entering the title' do
          before(:each) do
            new_post         = {}
            new_post[:title] = ''
            new_post[:body]  = Faker::Lorem.paragraph
            post :create, post: new_post, commit: 'Publish'
          end

          it { should respond_with :ok }
          it { should render_template :new }
          it { should render_with_layout :application }
          it { should set_flash.now[:alert].to("Title can't be blank") }
        end

        context 'when entering the same title as another post' do
          context 'on the same day' do
            before(:each) do
              other_post = create(:post)
              post :create, post: { title: other_post.title, body: Faker::Lorem.paragraph }, commit: 'Publish'
            end

            it { should respond_with :ok }
            it { should render_template :new }
            it { should render_with_layout :application }
            it { should set_flash.now[:alert].to('The title of two posts cannot be identical on the same day.') }
          end

          context 'not on the same day' do
            before(:each) do
              other_post = create(:post, created_at: Faker::Date.between(2.years.ago, Date.today))
              post :create, post: { title: other_post.title, body: Faker::Lorem.paragraph }, commit: 'Publish'
            end

            it { should respond_with :redirect }
            it { should redirect_to edit_post_path(assigns(:post).slug) }
            it { should set_flash[:notice].to('Your post has been published.') }
          end
        end

        context 'when entering a unique title' do
          before(:each) do
            create(:post)
            post :create, post: { title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph }, commit: 'Publish'
          end

          it { should respond_with :redirect }
          it { should redirect_to edit_post_path(assigns(:post).slug) }
          it { should set_flash[:notice].to('Your post has been published.') }
        end
      end

      context 'when the user attempts to save the post' do
        context 'when not entering the title' do
          before(:each) do
            new_post         = {}
            new_post[:title] = ''
            new_post[:body]  = Faker::Lorem.paragraph
            post :create, post: new_post, commit: 'Save'
          end

          it { should respond_with :ok }
          it { should render_template :new }
          it { should render_with_layout :application }
          it { should set_flash.now[:alert].to("Title can't be blank") }
        end

        context 'when entering the same title as another post' do
          context 'on the same day' do
            before(:each) do
              other_post = create(:post)
              post :create, post: { title: other_post.title, body: Faker::Lorem.paragraph }, commit: 'Save'
            end

            it { should respond_with :ok }
            it { should render_template :new }
            it { should render_with_layout :application }
            it { should set_flash.now[:alert].to('The title of two posts cannot be identical on the same day.') }
          end

          context 'not on the same day' do
            before(:each) do
              other_post = create(:post, created_at: Faker::Date.between(2.years.ago, Date.today))
              post :create, post: { title: other_post.title, body: Faker::Lorem.paragraph }, commit: 'Save'
            end

            it { should respond_with :redirect }
            it { should redirect_to edit_post_path(assigns(:post).slug) }
            it { should set_flash[:notice].to('Your post has been saved.') }
          end
        end

        context 'when entering a unique title' do
          before(:each) do
            create(:post)
            post :create, post: { title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph }, commit: 'Save'
          end

          it { should respond_with :redirect }
          it { should redirect_to edit_post_path(assigns(:post).slug) }
          it { should set_flash[:notice].to('Your post has been saved.') }
        end
      end
    end

    describe 'when the user is not signed in' do
      before(:each) do
        post :create, post: { title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph }, commit: 'Publish'
      end

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to('Please sign in to continue.') }
    end
  end

  describe 'GET #edit' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the post exists' do
        context 'when the user is the author of the post' do
          context 'when the post is published' do
            before(:each) do
              @post = create(:post, published: true, created_by: @controller.current_user)
              get :edit, slug: @post.slug
            end

            it { should respond_with :ok }
            it { should render_template :edit }
            it { should render_with_layout :application }
            it { expect(assigns(:post)).to eq(@post) }
          end

          context 'when the post has not yet been published' do
            before(:each) do
              @post = create(:post, published: false, created_by: @controller.current_user)
              get :edit, slug: @post.slug
            end

            it { should respond_with :ok }
            it { should render_template :edit }
            it { should render_with_layout :application }
            it { expect(assigns(:post)).to eq(@post) }
          end

          context 'when the user is not the author of the post' do
            before(:each) do
              post = create(:post, published: false)
              get :edit, slug: post.slug
            end

            it { should respond_with :redirect }
            it { should redirect_to root_path }
            it { should set_flash[:alert].to('You are not the author of the unpublished post.') }
          end
        end
      end

      context 'when the post does not exist' do
        before(:each) { get :edit, slug: 'blah' }

        it { should respond_with :redirect }
        it { should redirect_to root_path }
        it { should set_flash[:alert].to('The post you are looking for does not exist.') }
      end
    end

    context 'when the user is not signed in' do
      before(:each) do
        post = create(:post, published: false)
        get :edit, slug: post.slug
      end

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to 'Please sign in to continue.' }
    end
  end

  describe 'PATCH #update' do
    context 'when the user is signed in' do
      before(:each) { sign_in_as create(:user) }

      context 'when the post exists' do
        context 'when the user is the author of the post' do
          context 'when the user attempts to publish the post' do
            context 'when not entering the title' do
              before(:each) do
                post = create(:post, created_by: @controller.current_user)
                post.title = ''
                patch :update, post: { title: post.title, body: post.body }, commit: 'Publish', slug: post.slug
              end

              it { should respond_with :ok }
              it { should render_template :edit }
              it { should render_with_layout :application }
              it { should set_flash.now[:alert].to("Title can't be blank") }
            end

            context 'when entering the same title as another post' do
              context 'on the same day' do
                before(:each) do
                  other_post = create(:post)
                  post = create(:post, created_by: @controller.current_user)
                  patch :update, post: { title: other_post.title, body: post.body }, commit: 'Publish', slug: post.slug
                end

                it { should respond_with :ok }
                it { should render_template :edit }
                it { should render_with_layout :application }
                it { should set_flash.now[:alert].to('The title of two posts cannot be identical on the same day.') }
              end

              context 'not on the same day' do
                before(:each) do
                  other_post = create(:post, created_at: Faker::Date.between(2.years.ago, Date.yesterday))
                  post = create(:post, created_by: @controller.current_user)
                  patch :update, post: { title: other_post.title, body: post.body }, commit: 'Publish', slug: post.slug
                end

                it { should respond_with :redirect }
                it { should redirect_to show_post_path(assigns(:post).slug) }
                it { should set_flash[:notice].to('Your post has been published.') }
              end
            end

            context 'when entering a unique title' do
              before(:each) do
                post = create(:post, created_by: @controller.current_user)
                patch :update, post: { title: Faker::Lorem.sentence, body: post.body }, commit: 'Publish', slug: post.slug
              end

              it { should respond_with :redirect }
              it { should redirect_to show_post_path(assigns(:post).slug) }
              it { should set_flash[:notice].to('Your post has been published.') }
            end
          end
        end

        context 'when the user attempts to save the post' do
          context 'when not entering the title' do
            before(:each) do
              post = create(:post, created_by: @controller.current_user)
              post.title = ''
              patch :update, post: { title: post.title, body: post.body }, commit: 'Save', slug: post.slug
            end

            it { should respond_with :ok }
            it { should render_template :edit }
            it { should render_with_layout :application }
            it { should set_flash.now[:alert].to("Title can't be blank") }
          end

          context 'when entering the same title as another post' do
            context 'on the same day' do
              before(:each) do
                other_post = create(:post)
                post = create(:post, created_by: @controller.current_user)
                patch :update, post: { title: other_post.title, body: post.body }, commit: 'Save', slug: post.slug
              end

              it { should respond_with :ok }
              it { should render_template :edit }
              it { should render_with_layout :application }
              it { should set_flash.now[:alert].to('The title of two posts cannot be identical on the same day.') }
            end

            context 'not on the same day' do
              before(:each) do
                other_post = create(:post, created_at: Faker::Date.between(2.years.ago, Date.yesterday))
                post = create(:post, created_by: @controller.current_user)
                patch :update, post: { title: other_post.title, body: post.body }, commit: 'Save', slug: post.slug
              end

              it { should respond_with :redirect }
              it { should redirect_to show_post_path(assigns(:post).slug) }
              it { should set_flash[:notice].to('Your post has been saved.') }
            end
          end

          context 'when entering a unique title' do
            before(:each) do
              post = create(:post, created_by: @controller.current_user)
              patch :update, post: { title: Faker::Lorem.sentence, body: post.body }, commit: 'Save', slug: post.slug
            end

            it { should respond_with :redirect }
            it { should redirect_to show_post_path(assigns(:post).slug) }
            it { should set_flash[:notice].to('Your post has been saved.') }
          end
        end

        context 'when the user is not the author of the post' do
          before(:each) { patch :update, slug: create(:post).slug }

          it { should respond_with :redirect }
          it { should redirect_to root_path }
          it { should set_flash[:alert].to('You are not the author of the post.') }
        end
      end

      context 'when the post does not exist' do
        before(:each) { patch :update, slug: 'blah' }

        it { should respond_with :redirect }
        it { should redirect_to root_path }
        it { should set_flash[:alert].to('The post you are attempting to update does not exist.') }
      end

    end

    context 'when the user is not signed in' do
      before(:each) do
        post = create(:post, published: false)
        patch :update, slug: post.slug
      end

      it { should respond_with :redirect }
      it { should redirect_to sign_in_path }
      it { should set_flash[:notice].to 'Please sign in to continue.' }
    end
  end
end
