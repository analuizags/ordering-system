json.extract! order_product, :id, :quantity, :note, :order_id, :product_id, :created_at, :updated_at
json.url order_product_url(order_product, format: :json)
