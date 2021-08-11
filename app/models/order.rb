class Order < ActiveRecord::Base
  belongs_to :work_shift
  has_many :order_products
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, allow_destroy: true, reject_if: proc { |obj| obj[:quantity].to_i < 1 }
end
