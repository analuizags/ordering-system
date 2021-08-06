class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :owner
      t.boolean :active, default: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :restaurants, :name
  end
end
