class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]

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
    @post = Post.new(post_params)
    @post.created_by = current_user
    @post.published = true if params[:commit] == 'Publish'

    if @post.save
      message = case params[:commit]
                  when 'Publish'
                    'Your post has been published.'
                  when 'Save'
                    'Your post has been saved.'
                end
      redirect_to show_post_path(@post.slug), notice: message
    else
      message = @post.errors.full_messages.join('<br />')
      flash.now[:alert] = message
      render :new
    end
  end

  # GET /:slug
  def show
    @post = Post.find_by!(slug: params[:slug])
    unless @post.published?
      return redirect_to root_path, alert: 'You must be signed in to view the unpublished post.' unless signed_in?
      redirect_to root_path, alert: 'You are not the author of the unpublished post.'            unless @post.created_by == current_user
    end
  end

  # GET /:slug/edit
  def edit
    @post = Post.find_by!(slug: params[:slug])
    redirect_to root_path, alert: 'You are not the author of the unpublished post.' unless @post.created_by == current_user
  end

  # PUT /:slug
  # PATCH /:slug
  def update
    @post = Post.find_by!(slug: params[:slug])
    return redirect_to root_path, alert: 'You are not the author of the post.' unless @post.created_by == current_user
  end

  private

  def constraint
    flash.now[:alert] = 'The title of two posts cannot be identical on the same day.'
    render :new
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
