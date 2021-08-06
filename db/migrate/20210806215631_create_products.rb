class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name,         null: false
      t.integer :price_cents,              default: 0
      t.boolean :active,                   default: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :products, :name
  end
end
