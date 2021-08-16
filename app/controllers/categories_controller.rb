class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :activate, :deactivate]

  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    @category.activate!
    respond_to do |format|
      format.html { redirect_to categories_path, notice: 'Category was successfully activated.' }
      format.json { render :show, status: :ok, location: @category }
    end
  end

  def deactivate
    @category.deactivate!
    respond_to do |format|
      format.html { redirect_to categories_path, notice: 'Category was successfully disabled.' }
      format.json { render :show, status: :ok, location: @category }
    end
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :active, :see_in_kitchen)
    end
end
