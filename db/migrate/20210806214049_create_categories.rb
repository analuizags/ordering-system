class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,            null: false
      t.boolean :active,                      default: true
      t.boolean :see_in_kitchen,              default: false

      t.timestamps null: false
    end

    add_index :categories, :name
  end
end
