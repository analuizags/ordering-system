class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :cancel, :make, :done, :close]
  before_action :set_products, only: [:new, :edit, :update, :create]
  before_action :set_tables, only: [:new, :edit, :update, :create]
  before_action :set_categories, only: [:new, :edit, :update, :create]

  before_action :authenticate_user!

  def index
    @orders = Order.to_the(current_work_shift.try(:id)).order(:created_at)
  end

  def show
  end

  def new
    @order = Order.new

    set_products.each do |product|
      @order.order_products.build(product_id: product.id)
    end
  end

  def edit
    out_order_products = set_products.select { |product| !@order.products.include?(product) }

    out_order_products.each do |product|
      @order.order_products.build(product_id: product.id)
    end
  end

  def create
    @order = Order.new(order_params)

    @order.status = "registered"
    @order.work_shift_id = current_work_shift.id

    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_path, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    params[:order].delete(:status)
    params[:order].delete(:work_shift_id)

    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_path, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def make
    @order.order_products.each { |order_product| order_product.make! }

    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully making.' }
      format.json { render :show, status: :ok, location: @order }
    end
  end

  def done
    @order.order_products.each { |order_product| order_product.done! }

    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully done.' }
      format.json { render :show, status: :ok, location: @order }
    end
  end

  def reopen
    @order.reopen!
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully reopened.' }
      format.json { render :show, status: :ok, location: @order }
    end
  end

  def close
    @order.close!
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully closed.' }
      format.json { render :show, status: :ok, location: @order }
    end
  end

  def cancel
    @order.cancel!
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Order was successfully canceled.' }
      format.json { render :show, status: :ok, location: @order }
    end
  end

  private
    def set_products
      @products = Product.active.order("categories.name")
    end

    def set_categories
      @categories = Product.joins(:category).select("categories.id, categories.name").where(categories: {active: true}).uniq.order("categories.name")
    end

    def set_tables
      @tables = []
      (1..40).each {|n| @tables << "Mesa #{sprintf('%02d', n)}"}
      @tables
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:table, :status, :work_shift_id,
        order_products_attributes: [:id, :quantity, :note, :product_id])
    end
end
