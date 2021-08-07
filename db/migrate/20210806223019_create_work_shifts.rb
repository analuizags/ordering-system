class CreateWorkShifts < ActiveRecord::Migration
  def change
    create_table :work_shifts do |t|
      t.string :name, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.references :restaurant, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :work_shifts, :name
    add_index :work_shifts, :start_at
    add_index :work_shifts, :end_at
  end
end
