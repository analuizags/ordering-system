# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210806231240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",                           null: false
    t.boolean  "active",         default: true
    t.boolean  "see_in_kitchen", default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "order_products", force: :cascade do |t|
    t.integer  "quantity",   default: 0, null: false
    t.text     "note"
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "order_products", ["order_id"], name: "index_order_products_on_order_id", using: :btree
  add_index "order_products", ["product_id"], name: "index_order_products_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "table",                                null: false
    t.string   "status",        default: "registrado", null: false
    t.integer  "work_shift_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "orders", ["table"], name: "index_orders_on_table", using: :btree
  add_index "orders", ["work_shift_id"], name: "index_orders_on_work_shift_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "price_cents", default: 0
    t.boolean  "active",      default: true
    t.integer  "category_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["name"], name: "index_products_on_name", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "owner"
    t.boolean  "active",     default: true
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "restaurants", ["name"], name: "index_restaurants_on_name", using: :btree
  add_index "restaurants", ["user_id"], name: "index_restaurants_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_shifts", force: :cascade do |t|
    t.string   "name",                                       null: false
    t.datetime "start_at",   default: '2021-08-06 23:09:07', null: false
    t.datetime "end_at"
    t.integer  "product_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "work_shifts", ["end_at"], name: "index_work_shifts_on_end_at", using: :btree
  add_index "work_shifts", ["name"], name: "index_work_shifts_on_name", using: :btree
  add_index "work_shifts", ["product_id"], name: "index_work_shifts_on_product_id", using: :btree
  add_index "work_shifts", ["start_at"], name: "index_work_shifts_on_start_at", using: :btree

  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "work_shifts"
  add_foreign_key "products", "categories"
  add_foreign_key "restaurants", "users"
  add_foreign_key "work_shifts", "products"
end
