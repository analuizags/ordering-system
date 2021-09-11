class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :cancel, :make, :done, :close, :reopen]
  before_action :load_products, only: [:new, :edit, :update, :create]
  before_action :load_tables, only: [:new, :edit, :update, :create]
  before_action :load_categories, only: [:new, :edit, :update, :create]
  before_action :authenticate_user!

  def index
    # @orders = filter_orders.includes([:work_shift, :products])
    @orders = filter_orders

    @domains = {}
    @domains[:tables] = load_tables.map { |table| [table, table] }
    @domains[:products] = load_products.map { |product| [product.name, product.id] }
    @domains[:work_shifts] = load_work_shift_names.map { |work_shift| [work_shift, work_shift] }
    @domains[:statuses] = [['Registered', 'registered'], ['Closed','closed'], ['Canceled', 'canceled']]
  end

  def show
  end

  def new
    @order = Order.new

    @products.each do |product|
      @order.order_products.build(product_id: product.id)
    end
  end

  def edit
    @products.select { |product| !@order.products.include?(product) }.each do |product|
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

    def load_products
      @products = Product.active.order("categories.name")
    end

    def load_categories
      @categories = Product.joins(:category).select("categories.id, categories.name").where(categories: {active: true}).uniq.order("categories.name")
    end

    def load_tables
      @tables = []
      # (1..40).each do |n|
      #   @tables << {
      #     id: n,
      #     name: "Table #{sprintf('%02d', n)}"
      #   }
      # end
      (1..40).each {|n| @tables << "Table #{sprintf('%02d', n)}"}
      @tables
    end

    def load_work_shift_names
      names = []
      (1..4).each {|t| names << "Work Shift #{sprintf('%02d', t)}"}
      names
    end

    def current_orders
      Order.to_the(current_work_shift.try(:id)).order(:table, :created_at)
    end

    def filter_orders
      finder = OrdersFinder.new(
        params: order_find_params,
        init_collection: current_orders
      )

      finder.execute
    end

    def order_find_params
      filters = params.to_hash
      filters = filters.except('access_token', 'action', 'controller')
      filters
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:table, :status, :work_shift_id,
        order_products_attributes: [:id, :quantity, :note, :product_id])
    end
end
