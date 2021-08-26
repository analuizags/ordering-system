class AddStatusOnOrderProduct < ActiveRecord::Migration
  def change
    add_column :order_products, :making, :integer, default: 0
    add_column :order_products, :done, :integer, default: 0
  end
end
