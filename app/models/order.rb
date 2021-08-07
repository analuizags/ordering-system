class Order < ActiveRecord::Base
  belongs_to :work_shift
  has_many :order_products
  has_many :products, through: :order_products
end
