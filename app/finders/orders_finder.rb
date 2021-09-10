class OrdersFinder < BaseFinder
  attr_reader :init_collection, :params

  def execute
    orders = init_collection
    orders = by_work_shift(orders)
    orders = by_table(orders)
    orders = by_product(orders)
    orders = by_status(orders)
    orders = by_created_at_after(orders)
    orders = by_created_at_before(orders)
    orders = sort(orders)

    orders
  end

  private

  def by_work_shift(orders)
    return orders if params[:work_shift].nil?

    orders
      .joins(:work_shift)
      .where(work_shifts: { name: params[:work_shift] })
  end

  def by_table(orders)
    return orders if params[:table].nil?

    orders.where(table: params[:table])
  end

  def by_product(orders)
    return orders if params[:product_id].nil?

    orders
      .joins(:order_products)
      .where(order_products: { product_id: params[:product_id] })
  end

  def by_status(orders)
    return orders if params[:status].nil?

    orders.where(status: params[:status])
  end

  def by_created_at_after(orders)
    return orders unless params[:after]

    orders.where('orders.created_at >= ?', params[:after].to_date.beginning_of_day)
  end

  def by_created_at_before(orders)
    return orders unless params[:before]

    orders.where('orders.created_at <= ?', params[:before].to_date.end_of_day)
  end

  def sort(orders)
    orders.order(:table, :created_at)
  end
end
