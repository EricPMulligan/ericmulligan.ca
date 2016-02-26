class PostsController < ApplicationController
  before_action :require_login,     only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post_by_slug, only: [:show, :edit]
  before_action :find_post_by_id,   only: [:update, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /
  def index
    @posts = nil
    if signed_in?
      @posts = Post.includes(:created_by, :categories).where(['published = :published or created_by_id = :created_by', published: true, created_by: current_user.id]).latest.paginate(page: params[:page], per_page: 10)
    else
      @posts = Post.includes(:created_by, :categories).published.latest.paginate(page: params[:page], per_page: 10)
    end
  end

  # GET /index.rss
  def index_rss
    @posts = Post.includes(:categories).published.latest
    render layout: false
  end

  # GET /new
  def new
    @post = Post.new
  end

  # POST /
  def create
    @post            = Post.new(post_params)
    @post.created_by = current_user
    message = case params[:commit]
                when 'Publish'
                  @post.published    = true
                  @post.published_at = DateTime.now
                  'Your post has been published.'
                when 'Save As Draft'
                  'Your post has been saved.'
              end
    if @post.save
      redirect_to edit_post_path(@post.slug), notice: message
    else
      flash.now[:alert] = @post.errors.messages.has_key?(:slug) ?
                            ['<li>The title of two posts cannot be identical on the same day.</li>'] :
                            @post.errors.full_messages.map { |error| "<li>#{error}</li>" }
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
  end

  # PUT /posts/:id
  # PATCH /posts/:id
  def update
    post_hash = post_params
    message = case params[:commit]
                when 'Publish'
                  unless @post.published
                    post_hash[:published]    = true
                    post_hash[:published_at] = DateTime.now
                  end
                  'Your post has been published.'
                when 'Update'
                  'Your post has been saved.'
                when 'Unpublish'
                  post_hash[:published]    = false
                  post_hash[:published_at] = nil
                  'Your post has been unpublished.'
              end
    if @post.update(post_hash)
      redirect_to edit_post_path(@post.slug), notice: message
    else
      flash.now[:alert] = @post.errors.messages.has_key?(:slug) ?
                            ['<li>The title of two posts cannot be identical on the same day.</li>'] :
                            @post.errors.full_messages.map { |error| "<li>#{error}</li>" }
      render :edit
    end
  end

  # Delete /posts/:id
  def destroy
    if @post.destroy
      redirect_to root_path, notice: 'Your post has been deleted.'
    else
      redirect_to root_path, alert: @post.errors.full_messages.join('<br />')
    end
  end

  private

  def check_ownership
    redirect_to :back, alert: 'You are not the author of the post.' unless @post.created_by == current_user
  end

  def find_post_by_slug
    @post = Post.find_by!(slug: params[:slug])
  end

  def find_post_by_id
    @post = Post.find(params[:id])
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
      :body,
      :seo_title,
      :seo_description,
      :twitter_site,
      :category_ids => []
    )
  end
end
