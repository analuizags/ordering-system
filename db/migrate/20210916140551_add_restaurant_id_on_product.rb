class AddRestaurantIdOnProduct < ActiveRecord::Migration
  def change
    add_column :products, :restaurant_id, :integer, references: :restaurants
    add_column :categories, :restaurant_id, :integer, references: :restaurants
  end
end
