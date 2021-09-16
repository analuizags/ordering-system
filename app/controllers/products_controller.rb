class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :activate, :deactivate]
  before_action :load_categories, only: [:new, :edit, :update, :create]
  before_action :load_domains, only: [:index]
  before_action :authenticate_user!

  def index
    # @products = filter_products.page(params[:page]).per(20)
    @products = filter_products
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    @product.restaurant_id = current_restaurant.try(:id)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def activate
    @product.activate!
    respond_to do |format|
      format.html { redirect_to products_path, notice: 'Product was successfully activated.' }
      format.json { render :show, status: :ok, location: @product }
    end
  end

  def deactivate
    @product.deactivate!
    respond_to do |format|
      format.html { redirect_to products_path, notice: 'Product was successfully disabled.' }
      format.json { render :show, status: :ok, location: @product }
    end
  end

  private

    def load_domains
      @domains = {}
      @domains[:categories] = load_categories.map { |categry| [categry.name, categry.id] }
    end

    def load_categories
      @categories = Category.to_the(current_restaurant.try(:id)).order(:name)
      @categories.each do |category| 
        category.name = "#{category.name} - deactivate" if category.active == false
      end
    end

    def current_products
      Product.to_the(current_restaurant.try(:id)).default_order
    end

    def filter_products
      finder = ProductsFinder.new(
        params: product_find_params,
        init_collection: current_products
      )

      finder.execute
    end

    def product_find_params
      filters = params.to_hash
      filters = filters.except('access_token', 'action', 'controller')
      filters
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :active, :category_id)
    end
end
