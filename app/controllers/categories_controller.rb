class CategoriesController < ApplicationController
  before_action :require_login
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /categories
  def index
    @categories = Category.where(created_by: current_user).order(name: :asc).paginate(page: params[:page], per_page: 20)
  end

  # GET /categories/new
  def new

  end

  # POST /categories
  def create

  end

  # GET /categories/:id
  def show

  end

  # GET /categories/:id/edit
  def edit

  end

  # PUT /categories/:id
  # PATCH /categories/:id
  def update

  end

  # DELETE /categories/:id
  def destroy

  end

  # GET /coding
  def coding
  end

  # GET /music
  def music
  end

  # GET /other
  def other
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def record_not_found
    redirect_to categories_path, alert: 'The category you are looking for does not exist.'
  end
end
