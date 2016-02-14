class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post,     only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from SQLite3::ConstraintException, with: :constraint

  # GET /
  def index
    @posts = nil
    if signed_in?
      @posts = Post.published.union(Post.where(created_by: current_user, published: false)).latest.paginate(page: params[:page], per_page: 10)
    else
      @posts = Post.latest.published.paginate(page: params[:page], per_page: 10)
    end
  end

  # GET /new
  def new
    @post = Post.new
  end

  # POST /
  def create
    @post            = Post.new(post_params)
    @post.created_by = current_user
    @post.published  = true if params[:commit] == 'Publish'

    if @post.save
      message = case params[:commit]
                  when 'Publish'
                    'Your post has been published.'
                  when 'Save'
                    'Your post has been saved.'
                end
      redirect_to edit_post_path(@post.slug), notice: message
    else
      flash.now[:alert] = @post.errors.full_messages.join('<br />')
      render :new
    end
  end

  # GET /:slug
  def show
    unless @post.published?
      return redirect_to root_path, alert: 'You must be signed in to view the unpublished post.' unless signed_in?
      redirect_to root_path, alert: 'You are not the author of the unpublished post.'            unless @post.created_by == current_user
    end
  end

  # GET /:slug/edit
  def edit
    redirect_to root_path, alert: 'You are not the author of the unpublished post.' unless @post.created_by == current_user
  end

  # PUT /:slug
  # PATCH /:slug
  def update
    return redirect_to root_path, alert: 'You are not the author of the post.' unless @post.created_by == current_user

    if @post.update(post_params)
      message = case params[:commit]
                  when 'Publish'
                    'Your post has been published.'
                  when 'Save'
                    'Your post has been saved.'
                end
      redirect_to show_post_path(@post.slug), notice: message
    else
      flash.now[:alert] = @post.errors.full_messages.join('<br />')
      render :edit
    end
  end

  # Delete /:slug
  def destroy
    return redirect_to :back, alert: 'You are not the author of the post.' unless @post.created_by == current_user

    if @post.destroy
      redirect_to root_path, notice: 'Your post has been deleted.'
    else
      redirect_to root_path, alert: @post.errors.full_messages.join('<br />')
    end
  end

  private

  def constraint
    flash.now[:alert] = 'The title of two posts cannot be identical on the same day.'
    template = case params[:action]
                 when 'create'
                   :new
                 when 'update'
                   :edit
               end
    render template
  end

  def find_post
    @post = Post.find_by!(slug: params[:slug])
  end

  def record_not_found
    message = case params[:action]
                when 'show'
                  'The post you are looking for does not exist.'
                when 'edit'
                  'The post you are looking for does not exist.'
                when 'update'
                  'The post you are attempting to update does not exist.'
              end
    redirect_to root_path, alert: message
  end

  def post_params
    params.require(:post).permit(
      :title,
      :body
    )
  end
end
