class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :table, null: false
      t.string :status, null: false, default: "registrado"
      t.references :work_shift, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :orders, :table
  end
end
