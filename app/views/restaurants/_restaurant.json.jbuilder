json.extract! restaurant, :id, :name, :owner, :active, :user_id, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)
