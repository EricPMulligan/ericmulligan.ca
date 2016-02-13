class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /
  def index
    @posts = nil
    if signed_in?
      @posts = Post.published.union(Post.where(created_by: current_user, published: false)).paginate(page: params[:page], per_page: 10).latest
    else
      @posts = Post.latest.published.paginate(page: params[:page], per_page: 10)
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

  private

  def record_not_found
    redirect_to root_path, alert: 'The post you are looking for does not exist.'
  end
end
