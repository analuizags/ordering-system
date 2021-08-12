class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.integer :quantity, null: false, default: 0
      t.text :note
      t.references :order, index: true, foreign_key: true, null: false
      t.references :product, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
