class ProductsFinder < BaseFinder
  attr_reader :init_collection, :params

  def execute
    orders = init_collection
    orders = by_name(orders)
    orders = by_category(orders)
    orders = by_active(orders)
    orders = sort(orders)

    orders
  end

  private

  def by_name(orders)
    return orders if params[:name].nil?

    orders.where("products.name ILIKE ?", "%#{params[:name]}%")
  end

  def by_category(orders)
    return orders if params[:category_id].nil?

    orders.where(category_id: params[:category_id])
  end

  def by_active(orders)
    return orders if params[:active].nil?

    orders.where(active: params[:active])
  end

  def sort(orders)
    orders.order("categories.name, products.name")
  end

  def initialize_params(raw_params)
    new_params = raw_params.delete_if { |_, value| value.blank? && value != false}
    HashWithIndifferentAccess.new(new_params)
  end
end
